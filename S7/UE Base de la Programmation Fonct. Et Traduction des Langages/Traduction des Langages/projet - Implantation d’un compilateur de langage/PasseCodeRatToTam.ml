(* Module de la passe de creation du code *)
module PasseCodeRatToTam : Passe.Passe with type t1 = Ast.AstPlacement.programme and type t2 = string =
struct

  open Tds
  open Exceptions
  open Ast
  open AstPlacement

  type t1 = Ast.AstPlacement.programme
  type t2 = string

let n = "\n"

(* analyse_code_affectable : AstType.affectable -> String * (int * int * string ) *)
(* Paramètre a : affectable dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à un affectable *)
let rec analyse_code_affectable a =
  match a with
  | AstType.Ident infoast -> 
        begin match info_ast_to_info infoast with
            |InfoVar(_,t,d,r) ->  let taille = Type.getTaille t in
                                Printf.sprintf "LOAD (%d) %d[%s]" taille d r , (taille,d,r)
            | _ -> assert false
        end

  | AstType.Dereference a -> let str , (t,d,r) = analyse_code_affectable a in 
                              str ^n^ Printf.sprintf "LOADI (%d)" t , (t,d,r)

(* analyse_code_expression : AstType.expression -> String *)
(* Paramètre e : expression dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à cette expression *)
let rec analyse_code_expression e = 
  match e with
    |AstType.AppelFonction (infoast, el) -> 
         begin match info_ast_to_info infoast with
            | InfoFun(str,_,_) -> 
                (List.fold_left (fun code e -> code ^ n ^ (analyse_code_expression e)) "" el)
                 ^ "CALL (ST) " ^ str
            | _ -> assert false
         end
    |Binaire (b,e1,e2) ->
        (analyse_code_expression e1) ^ n ^ (analyse_code_expression e2) ^ n ^
        begin match b with
            (* appel des opérations suivant le type des expressions *)
            |Inf ->  "SUBR ILss" 
            |PlusInt ->   "SUBR IAdd" 
            |PlusRat -> "CALL (ST) radd"
            |MultInt -> "SUBR IMul"  
            |MultRat -> "CALL (ST) rmul"
            |EquBool -> "SUBR IEq" 
            |EquInt -> "SUBR IEq"
            |Fraction ->  "CALL (ST) norm" 
        end
    |Unaire (Numerateur,e1) -> analyse_code_expression e1 
    |Unaire (Denominateur,e1) -> analyse_code_expression e1
    |Entier (i) -> Printf.sprintf "LOADL %d" i
    |Booleen (b) -> if b then "LOADL 1" else "LOADL 0"
    (* créer un emplacement alloué en mémoire pour un pointeur avec MAlloc *)
    |New taille -> Printf.sprintf "LOADL %d \nSUBR MAlloc \n" taille
    |Null -> Printf.sprintf "LOADL %d \nSUBR MAlloc \n" 1
    |Adresse ia -> 
      begin match info_ast_to_info ia with 
        |InfoVar(_,_,d,r) -> Printf.sprintf "LOADA %d [%s] \n" d r
        | _ -> assert false
      end 
    |Affect a -> let str, _ = analyse_code_affectable a in str

(* analyse_code_instruction : AstType.instruction -> String * int *)
(* Paramètre i : instruction dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à cette instruction et la taille des variables 
qui ont été déclaré localement *)
let rec analyse_code_instruction i =
  match i with
  | AstType.Declaration (ia, e) -> 
      begin match info_ast_to_info ia with
      |InfoVar(_,t,i,reg) -> (Printf.sprintf "PUSH %d" (Type.getTaille t))
                            ^ n ^ (analyse_code_expression e)^ n ^
                          (Printf.sprintf "STORE  (%d) %d[%s] \n"  (Type.getTaille t) i reg) , Type.getTaille t
      |_ -> assert false
      end
  | Affectation (a,e) -> let str, (t,d,r) = analyse_code_affectable a in 
                           (analyse_code_expression e)^n^ str ^n^ (Printf.sprintf "STORE (%d) %d[%s]" t d r) , 0

  | AffichageInt e -> analyse_code_expression e ^ n ^ "SUBR IOut" ,0
  | AffichageBool e -> analyse_code_expression e ^ n ^ "SUBR BOut" ,0
  | AffichageRat e -> analyse_code_expression e ^ n ^ "CALL (ST) rout" ,0
  | AffichagePointeur e -> analyse_code_expression e ^ n ^ "SUBR IOut" ,0
  (* ajout d'étiquette pour les boucles avec des retours et des tests *)
  | Conditionnelle (c,t,e) -> 
    let etiqelse = Code.getEtiquette () and etiqfin = Code.getEtiquette () in
    analyse_code_expression c ^ n ^
    "JUMPIF (0) "^etiqelse ^n^
    (analyse_code_bloc t) ^n^
    "JUMP " ^ etiqfin ^n^
    etiqelse ^n^
    (analyse_code_bloc e) ^n^
    etiqfin  ,0

  | TantQue (c,b) -> 
    let etiqbloucle = Code.getEtiquette () and etiqfin = Code.getEtiquette () in
    etiqbloucle ^n^
    analyse_code_expression c ^n^
    "JUMPIF (0) "^etiqfin ^n^
    analyse_code_bloc b ^n^
    "JUMP " ^ etiqbloucle ^n^
    etiqfin   ,0
  | Retour (e) -> analyse_code_expression e  ,0
  | Empty -> "" ,0
  | AssignationAddInt (a,e) -> let str, (t,_,_) = analyse_code_affectable a in 
                           (analyse_code_expression e)^n^
                           str ^n^ "SUBR IAdd" ^n^
                            str ^n^ (Printf.sprintf "STOREI (%d)" t)  ,0
  | AssignationAddRat (a,e) -> let str, (t,_,_) = analyse_code_affectable a in 
                           (analyse_code_expression e)^n^
                           str ^n^ "CALL (ST) radd" ^n^
                            str ^n^ (Printf.sprintf "STOREI (%d)" t)  ,0
  | Typedef (_) -> " "  ,0

(* analyse_code_instruction : AstType.bloc -> String *)
(* Paramètre i : instruction dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM relatif à cette instruction *)
and analyse_code_bloc li = 
  let code = List.fold_left (fun code i -> let c,_ = analyse_code_instruction i in code^n^c ) "" li in
  let taille_var_loc = List.fold_left (fun taille i -> let _,t = analyse_code_instruction i in taille+t ) 0 li in

  code^n^(Printf.sprintf "POP (0) %d" taille_var_loc)

(* analyse d'une  fonction avec un retour qui renvoie les données en fonction de la taille
du paramètre de retour de la fonction, le HALT permet de ne pas rester bloquer dans
une focntion *)

(* analyse_code_fonction : AstPlacement.fonction -> String *)
(* Paramètre fonction : fonction dont on souhaite obtenir le code TAM *)
(* Renvoie le code TAM qui traduit cette fonction *)
let analyse_code_fonction (Fonction(iaf,_,b))  = 
 match info_ast_to_info iaf with
 |InfoFun(nom,t,lt) -> 
              let tailleparam = List.fold_left (fun taille t -> taille + (Type.getTaille t)) 0 lt in
              let tailleretour = Type.getTaille t in
              nom ^ n ^ (analyse_code_bloc b) 
                ^ n ^ Printf.sprintf "RETURN (%d) %d \n" tailleretour tailleparam 
                ^n^ "HALT \n"

 |_ -> assert false

(* analyse d'un programme, d'entete JUMP MAIN, et avec HALT pour arreter le programme à la fin *)

(* analyser : AstPlacement.programme -> String *)
(* Paramètre programme : programme à traduire *)
(* Renvoie le code TAM qui traduit le programme passé en paramètre *)
let analyser (Programme (fonctions,prog)) =
 Code.getEntete () ^n^n^
 List.fold_left (fun code e -> code ^ n ^ (analyse_code_fonction e)) "" fonctions
 ^n^
 "main"^n^
 analyse_code_bloc prog ^n^
 "HALT \n"

end
