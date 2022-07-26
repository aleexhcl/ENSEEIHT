open Passe

(* Définition d'un compilateur comme l'enchaînement de 
quatre passes (gestion des identifiants, typage, placement mémoire
génération de code). Chaque passe prend en entrée le type de
sortie de la passe précédente.
La dernière passe doit renvoyer une chaîne de caractères (le code généré)
*)
module Compilateur (Ptds:Passe) 
                    (Ptype:Passe with type t1 = Ptds.t2) 
                    (Pdep:Passe with type t1 = Ptype.t2) 
                    (Pcode:Passe with type t1 = Pdep.t2 and type t2 = string) : 
                    Passe with type t1 = Ptds.t1 and type t2 = string =
struct
  
  type t1 = Ptds.t1
  type t2 = string

(* analyse_semantique : ast -> string *)
(* Réalise l'analyse sémantique de l'arbre abstrait *)
(* en appliquant les passes les unes après les autres *)
(* retourne : le code issu de la dernière passe *)
  let analyser ast =
    let tast = Ptds.analyser ast in
    let tyast = Ptype.analyser tast in
    let past = Pdep.analyser tyast in
    let code = Pcode.analyser past in
    code
end


(* Compilateurs intermédiaires *)


(* Compilateur créant l'AST *)
(*
module CompilateurRat = Compilateur (PasseTdsNop) (PasseNop) (PasseNop) (PasseCodeNopNop)
*)

(* + passe de résolution des identifiants *)
(*
open PasseTdsRat
module CompilateurRat = Compilateur (PasseTdsRat) (PasseTypeNop) (PasseNop) (PasseCodeNopNop) 
*)
(* + passe de typage *)
(*
open PasseTdsRat
open PasseTypeRat
module CompilateurRat = Compilateur (PasseTdsRat) (PasseTypeRat) (PassePlacementNop) (PasseCodeNopNop)
*)
(* + passe de placement mémoire *)
(*
open PasseTdsRat
open PasseTypeRat
open PassePlacementRat
module CompilateurRat = Compilateur (PasseTdsRat) (PasseTypeRat) (PassePlacementRat) (PasseCodeNop)
*)

(* + passe de génération de code -> compilateur complet *)

open PasseTdsRat
open PasseTypeRat
open PassePlacementRat
open PasseCodeRatToTam
module CompilateurRat = Compilateur (PasseTdsRat) (PasseTypeRat) (PassePlacementRat) (PasseCodeRatToTam)


open Lexing


(* report_error : string -> Lexing.lexbuf -> string -> unit *)
(* Affiche un message d'erreur lorsque le fichier n'est pas conforme à la grammaire *)
(* filename : le nom du fichier non conforme *)
(* lexbuf : l'analyser lexical *)
(* msg : le message d'erreur à afficher *)
let report_error filename lexbuf msg =
 let (b,e) = (lexeme_start_p lexbuf, lexeme_end_p lexbuf) in
 let fc = b.pos_cnum - b.pos_bol + 1 in
 let lc = e.pos_cnum - b.pos_bol + 1 in
  Printf.eprintf "File \"%s\", line %d, characters %d-%d: %s\n" filename b.pos_lnum fc lc msg


(* compiler : string -> string *)
(* Compilter un code rat en un code TAM *)
(* Paramètre ratfile : le nom du fichier rat à compiler *)
(* Utilise le compilateur "CompilateurRat" pour générer le code associé au fichier rat *)
(* Erreur si soucis lors de l'analyse lexicale, l'analyse syntaxique,
 mauvaise utilisation des identifiants ou soucis de typage *)
let compiler ratfile =
  let input = open_in ratfile in
  let filebuf = Lexing.from_channel input in
  try
    let ast = Parser.main Lexer.token filebuf in
    "; " ^ ratfile ^ "\n" ^ (CompilateurRat.analyser ast)
  with
  | Lexer.Error _ as e ->
      report_error ratfile filebuf "lexical error (unexpected character).";
      raise e
  | Parser.Error as e->
      report_error ratfile filebuf "syntax error.";
      raise e

(* compilerVersFichier : string -> string -> () *)
(* Compiler un code rat en un code TAM et le sauve dans un fichier *)
(* ratfile : le nom du fichier rat à compiler *)
(* tamfile : le nom du fichier rat où sauver le résultat *)
let compilerVersFichier ratfile tamfile =
   let tamcode = compiler ratfile in
   let chan = open_out tamfile in
   output_string chan tamcode;
   close_out chan
