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
  parametre : arbre
  resultat : arbre fils *)
  val fils : arbre_reecriture -> arbre_reecriture list
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

  let rec fils (Noeud(terme, brl)) = match brl with 
    |[] -> []
    |(id,arb)::q -> arb::(fils (Noeud(terme,q)))

  let rec appartient terme (Noeud(mot, larbr)) =
    if terme = mot then true else
    match larbr with
    |[] -> (terme = mot)
    |(id,arb)::q -> ((appartient terme arb) || (appartient terme (Noeud(mot,q))))

  let arb1 = Noeud(['B';'O';'O'],[(1,Noeud(['B';'O';'O';'A'],[(2,Noeud(['B';'O';'O';'A';'O';'O';'A'],[]))]))])

end

let axiome = ['B';'O']
let a1 = ArbreReecritureBOA.creer_noeud axiome []

(*module SystemeBOA (AR : ArbreReecriture)(LR : Regle list)=
struct
  (* construire un arbre à partir d'un mot et de n règle
  type : char list -> int -> Regle list -> arbre_reecriture
  parametre : chaine de caractères et un entier n 
  resultat : arbre avec les derives du mot selon les regles *)
  let construit_arbre terme n lr =
  let rec construit_branches n lr =
    match (n,lr) with
    |0, _ -> []
    |_,[] -> []
    |k, r::rl -> (List.map (fun l -> (r.i, Noeud(l,(construit_arbre l n LR)))) (r.appliquer terme))@(construit_branches (n-1) rl)
  in Noeud(terme, construit_branches n lr); 

end**)

