(* interface des règles a créer *)
module type Regle =
sig
  (*id de l'identifiant des regles*)
  type tid = int
  type td
  (* utilité de la fonction
  Type : unit -> tid
  parametre : param d'entrée 
  resultat : identifiant de la regle *)
  val id : tid
  
  val appliquer : td -> td list
end

(* module implémentant la règle 1 du systeme boa *)
module Regle1 : Regle with type td = char list =
struct
  type tid = int
  type td = char list
  let id = 1
  let appliquer terme =
    match List.rev terme with 
    |[] -> [[]]
    |t::q -> if t = 'O' then [terme@['A']] else [terme]
end 


(* Definition de mot pour tester sles regles *)
let exemple1 = ['B';'O']
let exemple2 = ['B';'O';'A']
let exemple3 = ['B';'O';'O';'O';'O']
let exemple4 = ['B';'O';'A';'A';'O']

(*test règle 1*)
let%test _ = Regle1.appliquer exemple1 = [['B';'O';'A']]
let%test _ = Regle1.appliquer exemple2 = [['B';'O';'A']]
let%test _ = Regle1.appliquer exemple3 = [['B';'O';'O';'O';'O';'A']]
let%test _ = Regle1.appliquer exemple4 = [['B';'O';'A';'A';'O';'A']]

(* module implémentant la règle 2 du systeme boa *)
module Regle2 : Regle with type td = char list =
struct
  type tid = int
  type td = char list
  let id = 2
  let appliquer terme =
    match terme with 
    |[] -> [[]]
    |t::q -> if t = 'B' then [(t::q)@q] else [terme]
end 

(*test règle 2*)
let%test _ = Regle2.appliquer exemple1 = [['B';'O';'O']]
let%test _ = Regle2.appliquer exemple2 = [['B';'O';'A';'O';'A']]
let%test _ = Regle2.appliquer exemple3 = [['B';'O';'O';'O';'O';'O';'O';'O';'O']]
let%test _ = Regle2.appliquer exemple4 = [['B';'O';'A';'A';'O';'O';'A';'A';'O']]

(* module implémentant la règle 3 du systeme boa *)
module Regle3 : Regle with type td = char list =
struct
  type tid = int
  type td = char list
  let id = 3
  let rec appliquer terme =
    let chaineO = ['O';'O';'O'] and chaineA = ['A';'O';'A'] in
    match terme with
    |[] -> []
    |a::b::c::q -> if [a;b;c] = chaineO || [a;b;c] = chaineA then (('A')::q)::(List.map (fun l -> a::l) (appliquer (b::c::q)))
                    else (List.map (fun l -> a::l) (appliquer (b::c::q)))
    | t::q -> (List.map (fun l -> t::l) (appliquer q))
end 

(*test règle 3*)
let%test _ = Regle3.appliquer exemple1 = [['B';'O']]
let%test _ = Regle3.appliquer exemple2 = [['B';'O';'A']]
let%test _ = Regle3.appliquer exemple3 = [['B';'A';'O']; ['B';'O';'A']]
let%test _ = Regle3.appliquer exemple4 = [['B';'O';'A';'A';'O']]

(* module implémentant la règle 3 du systeme boa *)
module Regle4 : Regle with type td = char list =
struct
  type tid = int
  type td = char list
  let id = 4
  let rec appliquer terme =
    let chaine = ['A';'A'] in
    match terme with
    |[] -> []
    |a::b::q -> if [a;b] = chaine then q::(List.map (fun l -> a::l) (appliquer (b::q)))
                    else (List.map (fun l -> a::l) (appliquer (b::q)))
    | t::q -> (List.map (fun l -> t::l) (appliquer q))
end

let exemple5 = ['B';'A';'A';'A';'O';'A';'A']

(*test règle 4*)
let%test _ = Regle4.appliquer exemple1 = [['B';'O']]
let%test _ = Regle4.appliquer exemple2 = [['B';'O';'A']]
let%test _ = Regle4.appliquer exemple3 = [['B';'O';'O';'O';'O']]
let%test _ = Regle4.appliquer exemple4 = [['B';'O';'O']]
let%test _ = Regle4.appliquer exemple5 = [['B';'A';'O';'A';'A'];['B';'A';'0';'A';'A'];['B';'A';'A';'A';'O']]


(* interface des arbres de réécriture*)

module type ArbreReecriture =
sig
  type tid = int
  type td
  type arbre_reecriture = Noeud of td * (branche list) and branche = tid * arbre_reecriture
  (*créer un nouveau noeud avec un mot puis une liste suivant les reecriture 
  parametre : mot a ajouter à l'arbre 
  resultat : nouvel arbre *)
  val creer_noeud : td -> branche list -> arbre_reecriture
  (* fonction donannt la racine de l'arbre
  parametre : arbre de reecriture dont on veut la racine
  resultat : racine de l'arbre *)
  val racine : arbre_reecriture -> td
  (*renvoie les fils de l'arbre donné sous forme d'une liste 
  parametre : arbre et id de regle
  resultat : arbre fils *)
  val fils : arbre_reecriture -> tid -> arbre_reecriture list
  (* cherche si un mot appartient a un arbre
  parametre : mot et arbre 
  resultat : boolean *)
  val appartient : td -> arbre_reecriture -> bool
end

module  ArbreReecritureBOA : ArbreReecriture with type td = char list =
struct
  type tid = int
  type td = char list
  type arbre_reecriture = Noeud of td * (branche list) and branche = tid * arbre_reecriture
  let creer_noeud terme brl = (Noeud(terme, brl))
  let racine (Noeud(terme,brl)) = terme

  let rec fils (Noeud(terme, brl)) rid  = match (rid,brl) with 
    |k,[] -> []
    |k,(id,arb)::q -> if (k=id) then arb::(fils (Noeud(terme,q)) rid) else (fils (Noeud(terme,q)) rid)

  let rec appartient terme (Noeud(mot, larbr)) =
    if terme = mot then true else
    match larbr with
    |[] -> (terme = mot)
    |(id,arb)::q -> ((appartient terme arb) || (appartient terme (Noeud(mot,q))))

  let arb1 = Noeud(['B';'O';'O'],[(1,Noeud(['B';'O';'O';'A'],[(2,Noeud(['B';'O';'O';'A';'O';'O';'A'],[]))]))])

end

let axiome = ['B';'O']
let a1 = ArbreReecritureBOA.creer_noeud axiome []



module SystemeBOA =
struct
  (* construire un arbre à partir d'un mot et de n règle
  type : char list -> int -> arbre_reecriture
  parametre : chaine de caractères et un entier n 
  resultat : arbre avec les derives du mot selon les regles *)
  let rec construit_arbre terme n =
    let id = Regle1.id in
    let rec construit_branches p =
      match p with
      |0 -> []
      |k -> (List.map (fun l -> (id, ArbreReecritureBOA.creer_noeud l (construit_arbre l p))) (Regle1.appliquer terme))@(construit_branches (p-1))
    in ArbreReecritureBOA.creer_noeud terme (construit_branches n)

  (*let chemin term_depart term_cible n = *)
  

end
