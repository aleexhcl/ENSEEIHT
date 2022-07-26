(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)

(* Module de conversion des expressions en chaine *)
module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "("^e1^"+"^e2^")"
  let mult e1 e2 = "("^e1^"*"^e2^")"
end

(* Module d'évaluation des exemples *)
module EvalExemples2 =  ExemplesSimples (PrintSimple)

let%test _ = (EvalExemples2.exemple1 = "(1+(2*3))")
let%test _ = (EvalExemples2.exemple2 = "((5+2)*(2*3))")

(* Module pour compter le nombre d'opération dans une expression *)
module CompteSimple : ExprSimple with type t = int =
struct
  type t = int 
  let const _ = 0
  let plus e1 e2 = 1 + e1 + e2
  let mult e1 e2 = 1 + e1 + e2
end

(* Module d'évaluation des exemples *)
module EvalExemples3 =  ExemplesSimples (CompteSimple)

let%test _ = (EvalExemples3.exemple1 = 2)
let%test _ = (EvalExemples3.exemple2 = 3)


(* Module abstrayant les expressions *)
module type ExprVar =
sig
  type t
  val def : string -> t -> t -> t
  val var : string -> t
end

(* Module abstrayant les expressions *)
module type Expr =
sig
  include ExprSimple
  include (ExprVar with type t := t)
end

(* Module de conversion des expressions en chaine *)
module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let def str e1 e2 = "let "^str^" = "^e1^" in "^e2
  let var str = str
end

(* Définition des expressions *)
module ExemplesSimples2 (E:Expr) =
struct
  include ExemplesSimples(E)
  (* let a = 6 in (((a+2)*4)+(6*a)) *)
  let exemple3 = E.(def "a" (const 6) (plus (mult (plus (var "a") (const 2)) (const 4)) (mult (const 6) (var "a"))))
end

module Print : Expr with type t=string =
struct 
  include PrintSimple
  include PrintVar
end

(* Module d'évaluation des exemples *)
module EvalExemples4 =  ExemplesSimples2 (Print)

let%test _ = (EvalExemples4.exemple1 = "(1+(2*3))")
let%test _ = (EvalExemples4.exemple2 = "((5+2)*(2*3))")
let%test _ = (EvalExemples4.exemple3 = "let a = 6 in (((a+2)*4)+(6*a))") 

type tenv = (string*int) list ;;

module EvalVar : ExprVar with type t = int = 
struct
  type t = int
  val def str e1 e2 = 
end



