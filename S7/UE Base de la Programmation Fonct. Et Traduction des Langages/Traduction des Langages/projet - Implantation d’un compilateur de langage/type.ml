type typ = Bool | Int | Rat | Undefined | Pointeur of typ | TypeNomme of string | Enregistrement of (typ * string) list

let rec string_of_type t = 
  match t with
  | Bool ->  "Bool"
  | Int  ->  "Int"
  | Rat  ->  "Rat"
  | Undefined -> "Undefined"
  | Pointeur t -> "Pointeur " ^ (string_of_type t)
  | TypeNomme n -> n
  | Enregistrement _ -> "enreg : " 

let rec est_compatible t1 t2 =
  match t1, t2 with
  | Bool, Bool -> true
  | Int, Int -> true
  | Rat, Rat -> true 
  | Pointeur a, Pointeur b -> if a = Undefined || b = Undefined then true 
                   else est_compatible a b
  | Enregistrement l1, Enregistrement l2 -> let tl1,_ = List.split l1 and tl2,_= List.split l2 in
                          List.for_all2 est_compatible tl1 tl2
  | _ -> false 

let%test _ = est_compatible Bool Bool
let%test _ = est_compatible Int Int
let%test _ = est_compatible Rat Rat
let%test _ = not (est_compatible Int Bool)
let%test _ = not (est_compatible Bool Int)
let%test _ = not (est_compatible Int Rat)
let%test _ = not (est_compatible Rat Int)
let%test _ = not (est_compatible Bool Rat)
let%test _ = not (est_compatible Rat Bool)
let%test _ = not (est_compatible Undefined Int)
let%test _ = not (est_compatible Int Undefined)
let%test _ = not (est_compatible Rat Undefined)
let%test _ = not (est_compatible Bool Undefined)
let%test _ = not (est_compatible Undefined Int)
let%test _ = not (est_compatible Undefined Rat)
let%test _ = not (est_compatible Undefined Bool)
let%test _ = est_compatible (Pointeur Int) (Pointeur Int)
let%test _ = est_compatible (Pointeur Bool) (Pointeur Bool)
let%test _ = est_compatible (Pointeur Rat) (Pointeur Rat)
let%test _ = est_compatible (Pointeur (Pointeur Int)) (Pointeur (Pointeur Int))
let%test _ = not (est_compatible (Pointeur (Pointeur Int)) (Pointeur Int))
let%test _ = not (est_compatible (Undefined) (Pointeur Int))
let%test _ = est_compatible (Pointeur Rat) (Pointeur Undefined)
let%test _ = est_compatible (Pointeur Int) (Pointeur Undefined)
let%test _ = est_compatible (Pointeur (Pointeur Int)) (Pointeur Undefined)
let%test _ = est_compatible (Pointeur Bool) (Pointeur Undefined)
let%test _ = est_compatible (Enregistrement [ (Int,"i");(Rat,"r") ]) (Enregistrement [ (Int,"i2");(Rat,"r2") ])
let%test _ = est_compatible (Enregistrement [ (Pointeur Int,"i");(Rat,"r") ]) (Enregistrement [ (Pointeur Int,"i2");(Rat,"r2") ])
let%test _ = not (est_compatible (Enregistrement [ (Pointeur Int,"i");(Bool,"r") ]) (Enregistrement [ (Int,"i2");(Bool,"r2") ]))
let%test _ = est_compatible (Enregistrement [ (Int, "R1"); (Enregistrement [ (Int, "x"); (Int, "y")],"enr") ]) (Enregistrement [ (Int, "Rr"); (Enregistrement [ (Int, "r"); (Int, "yr")],"enrr") ])


let est_compatible_list lt1 lt2 =
  try
    List.for_all2 est_compatible lt1 lt2
  with Invalid_argument _ -> false

let%test _ = est_compatible_list [] []
let%test _ = est_compatible_list [Int ; Rat] [Int ; Rat]
let%test _ = est_compatible_list [Bool ; Rat ; Bool] [Bool ; Rat ; Bool]
let%test _ = not (est_compatible_list [Int] [Int ; Rat])
let%test _ = not (est_compatible_list [Int] [Rat ; Int])
let%test _ = not (est_compatible_list [Int ; Rat] [Rat ; Int])
let%test _ = not (est_compatible_list [Bool ; Rat ; Bool] [Bool ; Rat ; Bool ; Int])
let%test _ = not (est_compatible_list [Pointeur Bool ; Rat ; Bool] [Pointeur Bool ; Rat ; Bool ; Int])
let%test _ = (est_compatible_list [Bool ; Rat ; Pointeur Bool] [Bool ; Rat ; Pointeur Bool])
let%test _ = (est_compatible_list [Enregistrement [ (Pointeur Int,"i");(Rat,"r") ] ; Rat ; Pointeur Bool] [Enregistrement [ (Pointeur Int,"i6");(Rat,"r6") ] ; Rat ; Pointeur Bool])

let rec getTaille t =
  match t with
  | Int -> 1
  | Bool -> 1
  | Rat -> 2
  | Undefined -> 0
  | Pointeur _ -> 1
  | Enregistrement _ -> 1
  | _ -> 0
  
let%test _ = getTaille Int = 1
let%test _ = getTaille Bool = 1
let%test _ = getTaille Rat = 2
let%test _ = getTaille (Pointeur Rat) = 1
let%test _ = getTaille (Enregistrement [ (Int,"i");(Rat,"r") ]) = 1
