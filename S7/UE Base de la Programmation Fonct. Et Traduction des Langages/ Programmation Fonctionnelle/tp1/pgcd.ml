(*  Exercice à rendre **)
(*  TO DO : contrat *)
(*  pgcd : int -> int -> int  *)
(*  renvoie le pgcd de deux nombres entiers  *)
(*  a,b : les deux entiers  *)
(*  a et b sont des entiers positifs  *)

let rec pgcd a b = 
if a = b then a 
else if a > b then pgcd (a-b) b
else pgcd a (b-a) ;;

(*  tests unitaires *)
let%test _ = pgcd 1 1 = 1
let%test _ = pgcd 8 24 = 8
let%test _ = pgcd 1 67 = 1
let%test _ = pgcd 31 217 = 31
let%test _ = pgcd 14 21 = 7

(* Les préconditions pourraient être enlevées en utilisant au début de la fonction les valeurs absolues des entiers donnés en paramètre *)