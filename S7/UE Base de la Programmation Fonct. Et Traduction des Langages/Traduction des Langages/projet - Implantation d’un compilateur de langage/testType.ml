open Compilateur
open Exceptions

exception ErreurNonDetectee

(* ------------------------------ *)
(* Sans fonction                  *)
(* ------------------------------ *)


let%test_unit "testDeclaration1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration1.rat" in ()

let%test_unit "testDeclaration2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration2.rat" in ()

let%test_unit "testDeclaration3"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration3.rat" in ()

let%test_unit "testDeclaration4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration4.rat"
    in  raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

let%test_unit "testDeclaration5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Rat) -> ()

let%test_unit "testDeclaration6"= 
  try 
    let _ = compiler "../../fichiersRat//src-rat-type-test/testDeclaration6.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testDeclaration7"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration7.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testDeclaration8"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration8.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Int) -> ()

let%test_unit "testDeclaration9"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDeclaration9.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testAffectation1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation1.rat" in ()

let%test_unit "testAffectation2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation2.rat" in ()

let%test_unit "testAffectation3"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation3.rat" in ()

let%test_unit "testAffectation4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation4.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testAffectation5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

let%test_unit "testAffectation6"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation6.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Rat) -> ()

let%test_unit "testAffectation7"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation7.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Int) -> ()

let%test_unit "testAffectation8"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation8.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testAffectation9"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAffectation9.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testConditionnelle1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testConditionnelle1.rat" in ()

let%test_unit "testConditionnelle2"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testConditionnelle2.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testConditionnelle3"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testConditionnelle3.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testConditionnelle4"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testConditionnelle4.rat" in ()

let%test_unit "testConditionnelle5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testConditionnelle5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testConditionnelle6"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testConditionnelle6.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testRepetition1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRepetition1.rat" in ()

let%test_unit "testRepetition2"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRepetition2.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testRepetition3"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRepetition3.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testRepetition4"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRepetition4.rat" in ()

let%test_unit "testRepetition5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRepetition5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testRepetition6"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRepetition6.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testPrint1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testPrint1.rat" in ()

let%test_unit "testPrint2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testPrint2.rat" in ()

let%test_unit "testPrint3"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testPrint3.rat" in ()

let%test_unit "testRationnel1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRationnel1.rat" in ()

let%test_unit "testRationnel2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRationnel2.rat" in ()

let%test_unit "testRationnel3"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRationnel3.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Fraction,Int,Rat) -> ()

let%test_unit "testRationnel4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRationnel4.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Fraction,Bool,Int) -> ()

let%test_unit "testRationnel5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRationnel5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Int) -> ()

let%test_unit "testNumerateur1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testNumerateur1.rat" in ()

let%test_unit "testNumerateur2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testNumerateur2.rat" in ()

let%test_unit "testNumerateur3"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testNumerateur3.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Rat) -> ()

let%test_unit "testNumerateur4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testNumerateur4.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testNumerateur5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testNumerateur5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testDenominateur1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testDenominateur1.rat" in ()

let%test_unit "testDenominateur2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testDenominateur2.rat" in ()

let%test_unit "testDenominateur3"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDenominateur3.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Rat) -> ()

let%test_unit "testDenominateur4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDenominateur4.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testDenominateur5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testDenominateur5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testIdent1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent1.rat" in ()

let%test_unit "testIdent2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent2.rat" in ()

let%test_unit "testIdent3"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent3.rat" in ()

let%test_unit "testIdent4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent4.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Int) -> ()

let%test_unit "testIdent5"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent5.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Rat,Bool) -> ()

let%test_unit "testIdent6"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent6.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testIdent7"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent7.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testIdent8"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent8.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Rat) -> ()

let%test_unit "testIdent9"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testIdent9.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

let%test_unit "testOperation1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation1.rat" in ()

let%test_unit "testOperation2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation2.rat" in ()

let%test_unit "testOperation3"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation3.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Plus, Bool, Bool) -> ()

let%test_unit "testOperation4"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation4.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Equ, Rat, Rat) -> ()

let%test_unit "testOperation5"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation5.rat" in ()

let%test_unit "testOperation6"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation6.rat" in ()

let%test_unit "testOperation7"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation7.rat" in ()

let%test_unit "testOperation8"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation8.rat" in ()

let%test_unit "testOperation9"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation9.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Mult, Bool, Bool) -> ()

let%test_unit "testOperation10"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation10.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Inf, Rat, Rat) -> ()

let%test_unit "testOperation11"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation11.rat"
    in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu(Inf, Bool, Bool) -> ()

let%test_unit "testOperation12"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testOperation12.rat" in ()

(* Fichiers de tests de la génération de code -> doivent passer le typage *)

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

let%test_unit "code_complique" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/complique.rat" in ()






(* ------------------------------ *)
(* Avec fonction                  *)
(* ------------------------------ *)





let%test_unit "test2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/test2.rat" in ()

let%test_unit "testAppel1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel1.rat" in ()

let%test_unit "testAppel2"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel2.rat" in ()

let%test_unit "testAppel3"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel3.rat" in ()

let%test_unit "testAppel4"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel4.rat" in ()

let%test_unit "testAppel5"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel5.rat" in ()

let%test_unit "testAppel6"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel6.rat"
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel7"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel7.rat"
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel8"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel8.rat"
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

let%test_unit "testAppel9"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel9.rat"
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _ -> ()

(* let%test_unit "testAppel10"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel10.rat"
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _  -> ()

let%test_unit "testAppel11"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel11.rat"
    in raise ErreurNonDetectee
  with
  | TypesParametresInattendus _  -> () *)

let%test_unit "testAppel12"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel12.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Bool) -> ()

let%test_unit "testAppel13"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testAppel13.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Rat) -> ()

let%test_unit "testRetourFonction1"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRetourFonction1.rat" in ()

let%test_unit "testRetourFonction2"= 
  try 
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRetourFonction2.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

let%test_unit "testRetourFonction3"=
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRetourFonction3.rat" in ()

let%test_unit "testRetourFonction4"=
  try
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRetourFonction4.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Bool,Int) -> ()

(* 
let%test_unit "testRetourFonction5"=
  try
    let _ = compiler "../../fichiersRat/src-rat-type-test/testRetourFonction5.rat"
    in raise ErreurNonDetectee
  with
  | RetourDansMain -> () *)

let%test_unit "testRecursiviteFonction"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/testRecursiviteFonction.rat" in ()

let%test_unit "test"= 
  let _ = compiler "../../fichiersRat/src-rat-type-test/test.rat" in ()

let%test_unit "code_factrec" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/factrec.rat" in ()

(* Fichiers de tests de la génération de code -> doivent passer le typage *)

let%test_unit "code_testfun1" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun1.rat" in ()

let%test_unit "code_testfun2" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun2.rat" in ()

let%test_unit "code_testfun3" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun3.rat" in ()

let%test_unit "code_testfun4" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun4.rat" in ()

let%test_unit "code_testfun5" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun5.rat" in ()

let%test_unit "code_testfun6" = 
  let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfun6.rat" in ()

let%test_unit "code_testfuns" = 
let _ = compiler   "../../fichiersRat/src-rat-tam-test/testfuns.rat" in ()




(* test supp pour le projet *)

let%test_unit "code_pointeur_cours1" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/cours-1.rat" in ()

let%test_unit "testPointeursType1"=
  try
    let _ = compiler "../../fichiersRat/src-rat-projet/test_Type1.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Int,Pointeur Int) -> ()

let%test_unit "testPointeursType2"=
  try
    let _ = compiler "../../fichiersRat/src-rat-projet/test_Type2.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu(Pointeur Int,Int) -> ()

let%test_unit "testPointeursType3"=
  try
    let _ = compiler "../../fichiersRat/src-rat-projet/test_Type3.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu (Pointeur Int, Int) -> ()

let%test_unit "code_pointeur_type_null" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/test_Type4.rat" in ()

let%test_unit "testPointeursType4_err"=
  try
    let _ = compiler "../../fichiersRat/src-rat-projet/test_Type4_err.rat"
    in raise ErreurNonDetectee
  with
  | TypeInattendu (Pointeur Int, Pointeur Rat) -> ()

let%test_unit "code_assignaff" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/assignaff.rat" in ()

let%test_unit "code_assignaff" = 
try
  let _ = compiler   "../../fichiersRat/src-rat-projet/assignaff_Type1.rat" 
  in raise ErreurNonDetectee
  with
  | TypeInattendu (Bool, Int) -> ()

let%test_unit "code_assignaff" = 
try
  let _ = compiler   "../../fichiersRat/src-rat-projet/assignaff_Type2.rat" 
  in raise ErreurNonDetectee
  with
  | TypeInattendu (Pointeur Rat, Rat) -> ()


let%test_unit "code_deftype" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/deftype.rat" in ()

let%test_unit "code_deftype" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/deftype_ex2.rat" in ()

let%test_unit "code_enreg" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg.rat" in ()

let%test_unit "code_enreg2" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg2.rat" in ()

let%test_unit "code_enreg3" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg3.rat" in ()

let%test_unit "code_enreg4" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enreg4.rat" in ()

let%test_unit "code_enregtyp1" = 
try
  let _ = compiler   "../../fichiersRat/src-rat-projet/enregtype1.rat" 
  in raise ErreurNonDetectee
  with
  | TypeBinaireInattendu (Plus, Rat, Int) -> ()

let%test_unit "code_enregtyp2" = 
try
  let _ = compiler   "../../fichiersRat/src-rat-projet/enregtype2.rat" 
  in raise ErreurNonDetectee
  with
  | TypeInattendu (Rat, Bool) -> ()

let%test_unit "code_enregtype3" = 
  let _ = compiler   "../../fichiersRat/src-rat-projet/enregtype3.rat" in ()

let%test_unit "code_enregtyp4" = 
try
  let _ = compiler   "../../fichiersRat/src-rat-projet/enregtype4.rat" 
  in raise ErreurNonDetectee
  with
  | TypeInattendu (Int, Pointeur Int) -> ()

