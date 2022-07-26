(* Module de la passe de gestion du placement mémoire *)
module PassePlacementRat : Passe.Passe with type t1 = Ast.AstType.programme and type t2 = Ast.AstPlacement.programme =
struct

  open Tds
  open Exceptions
  open Ast
  open AstPlacement

  type t1 = Ast.AstType.programme
  type t2 = Ast.AstPlacement.programme

(* pas de placement en mémoire pour les affectables, les expressions, 
et les instructions autres que la déclaration et l'analyse des blocs
des conditionnelles *)

(* la définition des types n'apparait pas en mémoire car les variables 
ont déjà été associé à un type précédemment *)


(* analyse_placement_affectable : AstType.affectable -> Int *)
(* Renvoie l'indice de placement mémoire d'un affectable pour la pile *)
let rec analyse_placement_affectable _ _ _ = 0

(* analyse_placement_expression : AstType.expression -> Int *)
(* Renvoie l'indice de placement mémoire d'une expression pour la pile *)
let rec analyse_placement_expression _ _ _ = 0

(* analyse_placement_instruction : AstType.instruction -> Int *)
(* Paramètre base : indice de placement mémoire actuel *)
(* Parametre reg : registre dans lequel on place en mémoire *)
(* Paramètre i : instruction à placer en mémoire *)
(* Renvoie l'indice de placement mémoire de l'instruction pour la pile *)
let rec analyse_placement_instruction base reg i =
  match i with
  | AstType.Declaration (info,_) -> 
  begin match info_ast_to_info info with
    |InfoVar(_,t,_,_)->  modifier_adresse_info base reg info; Type.getTaille t
    |_ -> assert false
   end
  | AstType.Conditionnelle (_,t,e) -> 
      analyse_placement_bloc base reg t ; analyse_placement_bloc base reg e ; 0
  | AstType.TantQue (_,b) -> 
      analyse_placement_bloc base reg b ; 0
  | _ -> 0

(* analyse_placement_bloc : AstType.bloc -> unit *)
(* Paramètre base : indice de placement mémoire actuel *)
(* Parametre reg : registre dans lequel on place en mémoire *)
(* Paramètre bloc : bloc à placer en mémoire*)
(* Place en mémoire le bloc *)
and analyse_placement_bloc base reg bloc =
  ignore (
      List.fold_left (fun base instr -> 
            base + analyse_placement_instruction base reg instr)
            base bloc
  )


(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction *)
(* Paramètre fonction : fonction qui doit être placer en mémoire *)
(* Place une fonction en mémoire *)
let rec analyse_placement_fonction (AstType.Fonction(info,infos,bloc))  = 
    analyse_placement_param infos ;
    analyse_placement_bloc 3 "LB" bloc ;
    Fonction(info,infos,bloc) 

(* analyse_placement_param : list InfoVar -> unit *)
(* Paramètre infos : paramètres d'une fonction à placer en mémoire *)
(* Place une liste de paramètres en mémoire *)
and analyse_placement_param infos = 
    ignore (
        List.fold_right (fun info base -> 
            match info_ast_to_info info with 
            |InfoVar(_,t,_,_) -> let nbase = base - Type.getTaille t in 
                                modifier_adresse_info nbase "LB" info ; 
                                nbase
            | _ -> assert false 
            )
        infos 0
    )
(* analyser : AstType.Programme -> AstPlacement.Programme *)
(* Paramètre programme : programme à analyser *)
(* Effectue le traitement du placement mémoire du programme*)
let analyser (AstType.Programme (_,fonctions,bloc)) = 
  let nf = List.map analyse_placement_fonction fonctions in 
  let _ = analyse_placement_bloc 0 "SB" bloc in
  Programme (nf,bloc)
end
