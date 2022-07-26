(*** Combinaisons d'une liste ***)

(* CONTRAT 
Fonction qui génère les combinaisons de k éléments dans une liste d'éléments, 
dans l'ordre dans lequel les éléments apparaissent dans la liste
paramètres : k nombres d'éléments int, l liste d'éléments 'a list
resultat : liste des combinaisons 'a list list
*)
let rec combinaison k l =
match (k,l) with 
|(0,_) -> [[]]
|(_,[]) -> []
|(n,t::q) -> (List.map (fun li -> t::li) (combinaison (n-1) q) )@(combinaison n q) ;;

(* TESTS *)
(* TO DO *)
let%test _ = combinaison 0 [] = [[]]
let%test _ = combinaison 3 [] = []
let%test _ = combinaison 3 [1;2;3;4] = [[1;2;3];[1;2;4];[1;3;4];[2;3;4]]
let%test _ = combinaison 2 [1;2;3;4] = [[1;2];[1;3];[1;4];[2;3];[2;4];[3;4]]
let%test _ = combinaison 2 [a;b;c] = [[a;b];[a;c];[b;c]]
