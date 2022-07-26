let f1 (x,y) = x+y > 0;;
let f2 x = x > 0 ;;
let f3 x = x ;;
let f4 (x,y) = 
match x with
|y -> true
|_ -> false ;;
let f5 (x,y) = x ;;

let ieme t i =  
let (x,y,z)=t in
match i with|1 -> x|2 -> y|_ -> z ;;  

let rec pgcd a b = 
if a = b then a 
else if a > b then pgcd (a-b) b
else pgcd a (b-a) ;;

pgcd 1 1;;
pgcd 8 24;;
pgcd 1 67;;
pgcd 31 459;;
31 * 7;;
pgcd 31 217;;
pgcd 14 21;;