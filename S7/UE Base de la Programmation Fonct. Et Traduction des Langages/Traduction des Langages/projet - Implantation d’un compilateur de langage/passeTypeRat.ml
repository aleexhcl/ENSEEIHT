(* Module de la passe de gestion des types *)
module PasseTypeRat : Passe.Passe with type t1 = Ast.AstTds.programme and type t2 = Ast.AstType.programme =
struct

  open Tds
  open Exceptions
  open Ast
  open AstType

  type t1 = Ast.AstTds.programme
  type t2 = Ast.AstType.programme

(* analyse_type_typedef : AstTds.typedef -> AstType.typedef *)
(* Paramètre td : type à définir *)
(* analyse la définition d'un type nommé, modifie le type enregistré dans la tds*)
let rec analyse_type_typedef td =
  match td with 
  | AstTds.Deftype (ia,t) -> modifier_type_info t ia ; Deftype ia 

(* analyse_type_affectable : AstTds.affectable -> AstType.affectable 
Parametre a: affectable à analyser 
renvoie l'affectable et le type de l'affectable pour les traitements *)
(* analyse les types d'un affectable, erreur si déréference d'un type 
qui n'est pas un pointeur *)
let rec analyse_type_affectable a =
  match a with 
  | AstTds.Ident info_ast -> 
        begin match info_ast_to_info info_ast with 
            | InfoVar(_,t,_,_) -> (Ident info_ast),t
            | InfoFun(_,t, _) -> (Ident info_ast),t
            | InfoConst(_,_) -> (Ident info_ast),Int 
        end
  | AstTds.Dereference a -> let na,t = analyse_type_affectable a in
        begin match t with 
          | Pointeur nt -> Dereference na, nt
          | _ -> raise (TypePointeurAttendu t)
        end
  | AstTds.Acces (a,ia) -> let na,_= analyse_type_affectable a in 
                          begin match info_ast_to_info ia with 
                          | InfoVar(_,t,_,_) -> (Acces (na,ia)),t
                          | InfoFun(_,t, _) -> (Acces (na,ia)),t
                          | InfoConst(_,_) -> (Acces (na,ia)),Int 
                          end


(* analyse_type_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser 
renvoie l'expression analysée et le type de celle-ci *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)

let rec analyse_type_expression e = 
  match e with
    |AstTds.AppelFonction (infoast, el) -> 
        begin match info_ast_to_info infoast with 
            |InfoFun(_,tretour,tentree) ->                 
                    let nes,nt = List.(split (map analyse_type_expression el)) in
                    let bol = Type.est_compatible_list tentree nt in
                    
                    if bol then AppelFonction(infoast, nes), tretour 
                    else raise (TypesParametresInattendus (nt,tentree))
            | _ -> assert false
        end
    |AstTds.Binaire (b,e1,e2) -> let (ne1,t1) = analyse_type_expression e1 in
                                 let (ne2,t2) = analyse_type_expression e2 in      
                        begin match b,t1,t2 with
                          (* change l'opérateur binaire pour prendre en compte le type des expressions *)
                            |Inf,Int,Int -> Binaire(Inf,ne1,ne2), Bool
                            |Fraction,Int,Int -> Binaire(Fraction,ne1,ne2), Rat
                            |Plus,Int,Int -> Binaire(PlusInt,ne1,ne2), Int
                            |Plus,Rat,Rat -> Binaire(PlusRat,ne1,ne2), Rat
                            |Mult,Rat,Rat -> Binaire(MultRat,ne1,ne2), Rat
                            |Mult,Int,Int -> Binaire(MultInt,ne1,ne2), Int
                            |Equ,Int,Int -> Binaire(EquInt,ne1,ne2), Bool
                            |Equ,Bool,Bool -> Binaire(EquBool,ne1,ne2), Bool
                            |_ -> raise (TypeBinaireInattendu (b,t1, t2))
                        end
    |AstTds.Unaire (Numerateur,e1) -> let (e,t) = analyse_type_expression e1 in 
                        if Type.est_compatible t Rat then Unaire(Numerateur,e), Int
                        else raise (TypeInattendu (t, Rat))
    |AstTds.Unaire (Denominateur,e1) -> let (e,t) = analyse_type_expression e1 in 
                        if Type.est_compatible t Rat then Unaire(Denominateur,e), Int
                        else raise (TypeInattendu (t, Rat))
    |AstTds.Entier (i) -> Entier(i) , Int
    |AstTds.Booleen (b) -> Booleen(b) , Bool
    |AstTds.New t -> let taille = Type.getTaille t in 
                      New taille, Pointeur t
    |AstTds.Null -> Null , Pointeur Undefined (* est compatible avec tout autre pointeur *)
    |AstTds.Adresse ia -> 
      begin match info_ast_to_info ia with 
        |InfoVar (_,t,_,_) -> Adresse ia , Pointeur t
        | _ -> assert false
      end
    |AstTds.Affect a -> let na, t = analyse_type_affectable a in
                        Affect na, t
    |AstTds.DefEnregistrement le -> let nle,lt = List.(split(map analyse_type_expression le)) in 
                                    (* creer une liste pour renvoyer un type enregistrement *)
                                    let nlt = List.map (fun t -> (t,"")) lt in
                                    DefEnregistrement nle, Enregistrement nlt

(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre tr : type retour de l'instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstType.instruction , le type de retour sert à la
compatibilité des types à la fin de l'instruction *)
(* Erreur si mauvaise utilisation des types *)

let rec analyse_type_instruction tr i =
  match i with
  | AstTds.Declaration (t, ia, e) -> let ne,nt = analyse_type_expression e in
                                  begin match Type.est_compatible nt t with
                                        |true -> modifier_type_info t ia ; Declaration(ia,ne) 
                                        |false -> raise (TypeInattendu (nt,t)) 
                                  end
  | AstTds.Affectation (a,e) -> let ne,et = analyse_type_expression e in
                                  let na,at = analyse_type_affectable a in
                                  if Type.est_compatible et at then Affectation (na,ne)
                                  else raise (TypeInattendu (et,at))
  | AstTds.Affichage e -> 
      let ne,t = analyse_type_expression e in
        begin match t with 
            (* change l'expression Affichage selon le type de l'expression à afficher *)
            |Int -> (AffichageInt ne)
            |Bool -> (AffichageBool ne)
            |Rat -> (AffichageRat ne)
            |Pointeur _ -> (AffichagePointeur ne)
            | _ -> assert false
        end
  | AstTds.Conditionnelle (c,t,e) -> 
      let ce,ct = analyse_type_expression c in
      let te = analyse_type_bloc t tr in
      let ee = analyse_type_bloc e tr in
      begin match Type.est_compatible ct Bool with
            | true -> Conditionnelle(ce,te,ee)
            | false -> raise (TypeInattendu (ct,Bool))
      end
  | AstTds.TantQue (c,b) -> 
      let ce,ct = analyse_type_expression c in
      let te = analyse_type_bloc b tr in
      if Type.est_compatible ct Bool then 
            TantQue(ce,te)
      else raise (TypeInattendu (ct, Bool))

  | AstTds.Retour (e) -> 
     let (ne,t) = analyse_type_expression e in 
     if Type.est_compatible tr t then Retour(ne)
     else raise (TypeInattendu (t,tr)) 

  | AstTds.Empty -> Empty

  | AstTds.AssignationAdd (a,e) -> 
      let na,at = analyse_type_affectable a and ne,et = analyse_type_expression e in
      if Type.est_compatible et at then match et with 
        (* change l'assignation d'addition en fonction du type des expressions *)
        | Int -> AssignationAddInt (na,ne)
        | Rat -> AssignationAddRat (na,ne)
        | _ -> raise (TypeAssignationAttendu et)
      else raise (TypeInattendu (et,at))

  | AstTds.Typedef (td) -> Typedef (analyse_type_typedef td)

and analyse_type_bloc li tr =
   let nli= List.(map (analyse_type_instruction tr) li ) in nli

(* analyse_type_fonction : AstTds.fonction -> AstType.fonction
Paramee : fonction à analyser *)
(* analyse du type dans une fonction, on modifie dans la tds le type de retour 
et les types des paramètres *)
let analyse_type_fonction (AstTds.Fonction(t,ia,lp,li))  = 
  let tp,lia = List.split lp in 
  modifier_type_fonction_info t tp ia ;
  let _ = List.map2 modifier_type_info tp lia in 
  let nli = analyse_type_bloc li t in Fonction(ia,lia,nli) 

(* analyser : AstTds.programme -> AstType.programme 
Parametre : programme à analyser *)
(* analyse du type dans le programme, on analyse les types définis puis les fonctions 
puis le bloc du programme principal avec le type Undefinied comme type de
retour attendu *)
let analyser (AstTds.Programme (deftypes,fonctions,prog)) =
  let ndeft = List.map analyse_type_typedef deftypes in 
  let nf = List.map analyse_type_fonction fonctions in 
  let nb = analyse_type_bloc prog Undefined in
  Programme (ndeft,nf,nb)

end
