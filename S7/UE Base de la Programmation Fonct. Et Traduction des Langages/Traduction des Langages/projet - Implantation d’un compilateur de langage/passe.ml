(* Interface définissant une passe *)
module type Passe =
sig 
  (* type des AST en entrée de la passe *)
  type t1
  (* type des AST en sortie de la passe *)
  type t2

  (* fonction d'analyse qui tranforme un AST de type t1 
  en un AST de type t2 en réalisant des vérifications *)
  val analyser : t1 -> t2
end


(* Passe unit -> unit *)
(* Ne fait rien *)
(* Nécessaire aux compilateurs intermédiaires (non complets) *)
module PasseNop : Passe  with type t1 = unit and type t2 = unit =
struct
  type t1 = unit
  type t2 = unit

  let analyser _ = ()

end

(* Passe AstSyntax.programme -> unit *)
(* Ne fait rien *)
(* Nécessaire aux compilateurs intermédiaires (non complets) *)
module PasseTdsNop : Passe  with type t1 = Ast.AstSyntax.programme and type t2 = unit =
struct
  type t1 = Ast.AstSyntax.programme
  type t2 = unit

  let analyser _ = ()

end

(* Passe unit -> string *)
(* Ne fait rien *)
(* Nécessaire aux compilateurs intermédiaires (non complets) *)
module PasseCodeNopNop : Passe  with type t1 = unit and type t2 = string =
struct
  type t1 = unit
  type t2 = string

  let analyser _ = ""

end


(* Passe AstTds.programme -> unit *)
(* Ne fait rien *)
(* Nécessaire aux compilateurs intermédiaires (non complets) *)
module PasseTypeNop : Passe  with type t1 = Ast.AstTds.programme and type t2 = unit =
struct
  type t1 = Ast.AstTds.programme
  type t2 = unit

  let analyser _ = ()

end

(* Passe AstType.programme -> unit *)
(* Ne fait rien *)
(* Nécessaire aux compilateurs intermédiaires (non complets) *)
module PassePlacementNop : Passe  with type t1 =  Ast.AstType.programme and type t2 = unit =
struct
  type t1 = Ast.AstType.programme
  type t2 = unit

  let analyser _ = ()

end

(* Passe AstPlacement.programme -> string *)
(* Affiche les adresses des variables  *)
(* Pour tester les paramètres des fonctions, il est nécessaire de les mettre en retour *)
module PasseVerifPlacement : Passe  with type t1 =  Ast.AstPlacement.programme and type t2 = (string *(string*(int*string)) list) list =
struct
  open Tds
  type t1 = Ast.AstPlacement.programme
  type t2 = (string *(string*(int*string)) list) list


  (* Renvoie l'adresse d'une variable dans le cas d'une déclaration *)
  let rec analyser_instruction i = 
    match i with
    | Ast.AstType.Declaration (info,_) -> 
      begin
        match Tds.info_ast_to_info info with
        | InfoVar (n,_,d,r) -> [(n,(d,r))]
        | _ -> []
        end
    | Ast.AstType.Conditionnelle(_,bt,be) -> (List.flatten (List.map (analyser_instruction) bt))@(List.flatten (List.map (analyser_instruction) be))
    | Ast.AstType.TantQue (_,b) -> (List.flatten (List.map (analyser_instruction) b))
    | _ -> [] ;;


let analyser_param info =
  match Tds.info_ast_to_info info with
  | InfoVar (n,_,d,r) -> [(n,(d,r))]
  | _ -> []

  (* Renvoie la suite des adresses des variables déclarées dans la fonction *)
  (* Ainsi qu'une adresse d'identifiant si le retour est un identifiant *)
  let analyser_fonction (Ast.AstPlacement.Fonction(info,lp,li)) =
    (*La liste des paramètres n'est plus présente, pour tester le placement des paramètres, on utilisera une astuce :
    il faudra écrire un programme qui renvoie le paramètre *)
    match info_ast_to_info info with
    | InfoFun(n,_,_) -> [(n,(List.flatten (List.map analyser_param lp))@(List.flatten (List.map (analyser_instruction) li)))]
    | _ -> failwith "Internal error"

  (* Renvoie la suite des adresses des variables déclarées dans les fonctions et dans le programme principal *)
  let analyser (Ast.AstPlacement.Programme (fonctions, prog)) =
    ("main", List.flatten (List.map (analyser_instruction) prog))::(List.flatten (List.map (analyser_fonction) fonctions))

end

(* Passe AstPlacement.programme -> string *)
(* Ne fait rien *)
(* Nécessaire aux compilateurs intermédiaires (non complets) *)
module PasseCodeNop : Passe  with type t1 = Ast.AstPlacement.programme and type t2 = string =
struct
  type t1 = Ast.AstPlacement.programme
  type t2 = string

  let analyser _ = ""

end
