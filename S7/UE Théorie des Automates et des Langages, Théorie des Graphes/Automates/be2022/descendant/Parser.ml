open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptIDENT : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un identifiant *)
(* et avance dans l'analyse si c'est le cas *)
let acceptIDENT stream =
  match (peekAtFirstToken stream) with
    | (UL_IDENT _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptIdent : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un identifiant *)
(* et avance dans l'analyse si c'est le cas *)
let acceptident stream =
  match (peekAtFirstToken stream) with
    | (UL_ident _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;

(* acceptEntier : inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien un identifiant *)
(* et avance dans l'analyse si c'est le cas *)
let acceptEntier stream =
  match (peekAtFirstToken stream) with
    | (UL_ENTIER _) -> (Success (advanceInStream stream))
    | _ -> Failure
;;

(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseMachine : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parseR stream =
  (print_string "R -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 1 *)
    | UL_MODEL -> 
        inject stream >>=
        accept UL_MODEL >>=
        acceptIDENT >>=
        accept UL_ACCOUV >>=
        parseSE >>=
        accept UL_ACCFER
    | _ -> Failure)

(* parseSE : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseSE stream =
  (print_string "SE -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 2 *)
    | UL_ACCFER -> inject stream
    (* Règle 3 *)
    | (UL_BLOCK | UL_SYS | UL_FLOW) -> 
        inject stream >>=
        parseE >>=
        parseSE
    | _ -> Failure)

(* parseE : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseE stream =
  (print_string "E -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 4 *)
    | UL_BLOCK -> 
        inject stream >>=
        accept UL_BLOCK >>=
        acceptIDENT >>=
        parseP >>=
        accept UL_PTVIRG
    (* Règle 5 *)
    | UL_SYS -> 
        inject stream >>=
        accept UL_SYS >>=
        acceptIDENT >>=
        parseP >>=
        accept UL_ACCOUV >>=
        parseSE >>=
        accept UL_ACCFER
    (* Règle 6 *)
    | UL_FLOW -> 
        inject stream >>=
        accept UL_FLOW >>=
        acceptident >>=
        accept UL_FROM >>=
        parseNQ >>=
        accept UL_TO >>=
        parseLN >>=
        accept UL_PTVIRG
    | _ -> Failure)

(* parseNQ : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseNQ stream =
  (print_string "NQ -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 7 *)
    | (UL_ident _) -> 
        inject stream >>=
        acceptident 
    (* Règle 8 *)
    | (UL_IDENT _) -> 
        inject stream >>=
        acceptIDENT >>=
        accept UL_PT >>=
        acceptident
    | _ -> Failure)

(* parseLN : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseLN stream =
  (print_string "LN -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 9 *)
    | UL_PTVIRG -> inject stream
    (* Règle 10 *)
    | ((UL_IDENT _) | (UL_ident _)) -> 
        inject stream >>=
        parseNQ >>=
        parseSN
    | _ -> Failure)

(* parseSN : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseSN stream =
  (print_string "SN -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 11 *)
    | UL_PTVIRG -> inject stream
    (* Règle 12 *)
    | UL_VIRG -> 
        inject stream >>=
        accept UL_VIRG >>=
        parseNQ >>=
        parseSN
    | _ -> Failure)

(* parseP : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseP stream =
  (print_string "P -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 13 *)
    | UL_PAROUV -> 
        inject stream >>=
        accept UL_PAROUV >>=
        parseLP >>=
        accept UL_PARFER
    | _ -> Failure)

(* parseLP : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseLP stream =
  (print_string "LP -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 14 *)
    | (UL_ident _) -> 
        inject stream >>=
        parseDP >>=
        parseSP
    | _ -> Failure)

(* parseSP : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseSP stream =
  (print_string "SP -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 15 *)
    | UL_PARFER -> inject stream
    (* Règle 16 *)
    | UL_VIRG -> 
        inject stream >>=
        accept UL_VIRG >>=
        parseDP >>=
        parseSP
    | _ -> Failure)

(* parseDP : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseDP stream =
  (print_string "DP -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 17 *)
    | (UL_ident _) -> 
        inject stream >>=
        acceptident >>=
        accept UL_DXPT >>=
        parseM >>=
        parseT >>=
        parseOT
    | _ -> Failure)

(* parseM : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseM stream =
  (print_string "M -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 18 *)
    | UL_IN -> 
        inject stream >>=
        accept UL_IN
    (* Règle 19 *)
    | UL_OUT -> 
        inject stream >>=
        accept UL_OUT
    | _ -> Failure)

(* parseT : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseT stream =
  (print_string "T -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 20 *)
    | UL_INT -> 
        inject stream >>=
        accept UL_INT 
    (* Règle 21 *)
    | UL_FLOAT -> 
        inject stream >>=
        accept UL_FLOAT
    (* Règle 22 *)
    | UL_BOOL -> 
        inject stream >>=
        accept UL_BOOL
    | _ -> Failure)

(* parseOT : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseOT stream =
  (print_string "OT -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 23 *)
    | (UL_VIRG | UL_PARFER) -> inject stream
    (* Règle 24 *)
    | UL_CROOUV -> 
        inject stream >>=
        accept UL_CROOUV >>=
        acceptEntier >>=
        parseSV >>=
        accept UL_CROFER
    | _ -> Failure)

(* parseSV : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
and parseSV stream =
  (print_string "SV -> ...");
  (match (peekAtFirstToken stream) with
    (* Règle 25 *)
    | UL_CROFER -> inject stream
    (* Règle 26 *)
    | UL_VIRG -> 
        inject stream >>=
        accept UL_VIRG >>=
        acceptEntier >>=
        parseSV 
    | _ -> Failure)
;;
