open Compilateur
open Exceptions

exception ErreurNonDetectee;;


(* ------------------------------ *)
(* Sans fonction                  *)
(* ------------------------------ *)


let%test_unit "testAffectation1" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testAffectation1.rat" in ()

let%test_unit "testAffectation2"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testAffectation2.rat" 
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testAffectation3" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testAffectation3.rat" in ()

let%test_unit "testAffectation4" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testAffectation4.rat"
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> ()

let%test_unit "testUtilisation1" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation1.rat" in ()

let%test_unit "testUtilisation2" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation2.rat" in ()

let%test_unit "testUtilisation3" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation3.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation10" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation10.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testUtilisation11" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation11.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation12" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation12.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation13" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation13.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation14" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation14.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation15" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation15.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("z") -> ()

let%test_unit "testUtilisation16" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation16.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation17" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation17.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation18" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation18.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation19" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation19.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testRecursiviteVariable" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testRecursiviteVariable.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

(* Fichiers de tests de la génération de code -> doivent passer la TDS *)

let%test_unit "code_testprintint" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testprintint.rat" in ()

let%test_unit "code_testprintbool" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testprintbool.rat" in ()

let%test_unit "code_testprintrat" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testprintrat.rat" in ()

let%test_unit "code_testaddint" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testaddint.rat" in ()

let%test_unit "code_testaddrat" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testaddrat.rat" in ()

let%test_unit "code_testmultint" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testmultint.rat" in ()

let%test_unit "code_testmultrat" = 
let _ = compiler  "../../fichiersRat/src-rat-tam-test/testmultrat.rat" in ()

let%test_unit "code_testnum" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/testnum.rat" in ()

let%test_unit "code_testdenom" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/testdenom.rat" in ()

let%test_unit "code_testwhile1" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/testwhile1.rat" in ()

let%test_unit "code_testif1" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/testif1.rat" in ()

let%test_unit "code_testif2" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/testif2.rat" in ()

let%test_unit "code_factiter" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/factiter.rat" in ()

(* ------------------------------ *)
(* Avec fonction                  *)
(* ------------------------------ *)

let%test_unit "testDoubleDeclarationVariable1" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable1.rat"
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()  

let%test_unit "testDoubleDeclarationVariable2" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable2.rat" in ()

let%test_unit "testDoubleDeclarationVariable3" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable3.rat" in ()
	  
let%test_unit "testDoubleDeclarationVariable4" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable4.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testDoubleDeclarationVariable5" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable5.rat"
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testDoubleDeclarationVariable6" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable6.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testDoubleDeclarationVariable7" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationVariable7.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> ()

let%test_unit "testAffectation5" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testAffectation5.rat"
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("add") -> ()
  | MauvaiseUtilisationIdentifiant("add2") -> ()

let%test_unit "testUtilisation4" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation4.rat"
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("add") -> ()

let%test_unit "testUtilisation5" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation5.rat"
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("add") -> ()

let%test_unit "testUtilisation6" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation6.rat" in ()

let%test_unit "testUtilisation7" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation7.rat" in ()

let%test_unit "testUtilisation8" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation8.rat"
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> ()

let%test_unit "testUtilisation9" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation9.rat"
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("z") -> ()

let%test_unit "testUtilisation20" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation20.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation21" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation21.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation22" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation22.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("y") -> ()

let%test_unit "testUtilisation23" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation23.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testUtilisation24" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation24.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("x") -> ()

let%test_unit "testUtilisation25" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation25.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("a") -> ()

let%test_unit "testUtilisation26" = 
  try 
    let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation26.rat"
    in raise ErreurNonDetectee
  with
  | IdentifiantNonDeclare("a") -> ()

let%test_unit "testUtilisation27" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testUtilisation27.rat" in ()

let%test_unit "testDeclarationFonction" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testDeclarationFonction.rat" in ()

let%test_unit "testDoubleDeclarationFonction" = 
try 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationFonction.rat"
  in raise ErreurNonDetectee
with
| DoubleDeclaration("add") -> ()

let%test_unit "testDoubleDeclarationParametre1" = 
try 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationParametre1.rat"
  in raise ErreurNonDetectee
with
| DoubleDeclaration("a") -> ()

let%test_unit "testDoubleDeclarationParametre2" = 
try 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/testDoubleDeclarationParametre2.rat"
  in raise ErreurNonDetectee
with
| DoubleDeclaration("a") -> ()

let%test_unit "testRecursiviteFonction" = 
let _ = compiler "../../fichiersRat/src-rat-tds-test/testRecursiviteFonction.rat" in ()

let%test_unit "test"= 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/test.rat" in ()

let%test_unit "test2" = 
  let _ = compiler "../../fichiersRat/src-rat-tds-test/test2.rat" in ()

(* Fichiers de tests de la génération de code -> doivent passer la TDS *)

let%test_unit "code_factrec" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/factrec.rat" in ()

let%test_unit "code_testfun1" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun1.rat" in ()

let%test_unit "code_testfun2" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun2.rat" in ()

let%test_unit "code_testfun3" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun3.rat" in ()

let%test_unit "code_testfun4" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun4.rat" in ()

let%test_unit "code_testfuns" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfuns.rat" in ()

let%test_unit "code_complique" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/complique.rat" in ()



(* test supplementaires *)

let%test_unit "code_pointeur_cours1" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/cours-1.rat" in ()

let%test_unit "code_pointeur_cours1_DoubleDecla" = 
  try 
    let _ = compiler   "../../fichiersRat/src-rat-projet/cours-1-DoubleDecla.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("px") -> () 

let%test_unit "code_assignaff" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/assignaff.rat" in ()

let%test_unit "code_assignaff_DoubleDecla" = 
  try 
    let _ = compiler   "../../fichiersRat/src-rat-projet/assignaff_doubledecla.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("i") -> () 

let%test_unit "code_deftype" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/deftype.rat" in ()

let%test_unit "code_deftype2" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/deftype_ex2.rat" in ()

let%test_unit "code_enreg" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg.rat" in ()

let%test_unit "code_enreg2" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg2.rat" in ()

let%test_unit "code_enreg3" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg3.rat" in ()

let%test_unit "code_enreg_DoubleDecla" = 
  try 
    let _ = compiler   "../../fichiersRat/src-rat-projet/enregDoubleDe.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> () 

let%test_unit "code_enreg_DoubleDecla2" = 
  try 
    let _ = compiler   "../../fichiersRat/src-rat-projet/enregDoubleDe2.rat" 
    in raise ErreurNonDetectee
  with
  | DoubleDeclaration("x") -> () 

let%test_unit "code_enreg4" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg4.rat" in ()

let%test_unit "code_enreg_MauvUtil" = 
  try 
    let _ = compiler   "../../fichiersRat/src-rat-projet/enregMauvUtil.rat" 
    in raise ErreurNonDetectee
  with
  | MauvaiseUtilisationIdentifiant("x") -> () 



let%test_unit "code_enregRecu" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enregRecu.rat" in ()

let%test_unit "code_exlong" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/exlong.rat" in ()

