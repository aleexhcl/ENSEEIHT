open Util
open Mem

(* get_assoc: retourne la valeur associée à la clef dans la liste donnée
type : 'a -> ('a * 'b) list -> 'b -> 'b
parametres : e, clef de la valeur, l, liste associative 
resultat : valeur de la clef , ou def si la clef n'existe pas dans la liste
 *)
let rec get_assoc e l def = 
match l with
|[] -> def
|(clef,valeur)::_ when clef = e -> valeur
|_::q -> get_assoc e q def

(* Tests unitaires *)
let ex1 = [(1,'a');(2,'b');(3,'c')]
let ex2 = [("un",1);("deux",2);("trois",3)]

let%test _ = get_assoc 3 ex1 '0' = 'c'
let%test _ = get_assoc "un" ex2 0 = 1
let%test _ = get_assoc 'a' [] "pas de clef" = "pas de clef"

(* set_assoc : remplace la valeur associée à une clef donnée par une autre valeur 
dans une liste
type : 'a -> ('a * 'b) list -> 'b -> ('a * 'b) list
paramtres : e, clef dont on change la valeur, l, liste associative, x, nouvelle valeur
resultat : liste avec la valeur x pour la clef e, avec ajout du couple (e,x) si la
clef e n'était pas dans l *)
let rec set_assoc e l x = 
match l with
|[] -> [(e,x)]
|(clef,v)::q -> if clef = e then (e,x)::q else (clef,v)::(set_assoc e q x)

(* Tests unitaires *)
let%test _ = set_assoc 'a' [] ['a'] = [('a',['a'])]
let%test _ = set_assoc 2 ex1 'k' = [(1,'a');(2,'k');(3,'c')]
let%test _ = set_assoc "trois" ex2 6 = [("un",1);("deux",2);("trois",6)]


module AssocMemory : Memory =
struct
    (* Type = liste qui associe des adresses (entiers) à des valeurs (caractères) *)
    type mem_type = (int * char) list

    (* Un type qui contient la mémoire + la taille de son bus d'adressage *)
    type mem = int * mem_type

    (* Nom de l'implémentation *)
    let name = "assoc"

    (* Taille du bus d'adressage *)
    let bussize (bs, _) = bs

    (* Taille maximale de la mémoire *)
    let size (bs, _) = pow2 bs

    (* Taille de la mémoire en mémoire *)
    let allocsize (_, m) = (List.length m)*2

    (* Nombre de cases utilisées *)
    let busyness (_, m) = 
        List.fold_right (fun (clef,va) nb -> if clef = 0 && va = _0 then nb 
                          else 1 + nb ) m 0

    (* Construire une mémoire vide *)
    let clear bs =
    let rec aux bs mem = if bs > 0 then aux (bs-1) ((0,_0)::mem) else mem in 
    (bs, aux bs [])

    (* Lire une valeur *)
    let read (bs, m) addr = if addr < size (bs, m) then get_assoc addr m _0 else raise OutOfBound

    (* Écrire une valeur *)
    let write (bs, m) addr x = if busyness (bs,m) + addr < size (bs,m) then (bs, set_assoc addr m x) 
                                else raise OutOfBound
end
