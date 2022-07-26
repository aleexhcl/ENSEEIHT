%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

(* let nbrVariables = ref 0;; *)

let nbrFonctions = ref 0;;

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token IMPORT
%token <string> IDENT TYPEIDENT
%token INT FLOAT BOOL CHAR VOID STRING
%token ACCOUV ACCFER PAROUV PARFER CROOUV CROFER
%token PTVIRG VIRG
%token SI SINON TANTQUE RETOUR
/* Defini le type des donnees associees a l'unite lexicale */
%token <int> ENTIER
%token <float> FLOTTANT
%token <bool> BOOLEEN
%token <char> CARACTERE
%token <string> CHAINE
%token VIDE
%token NOUVEAU
%token ASSIGN
%token OPINF OPSUP OPINFEG OPSUPEG OPEG OPNONEG
%token OPPLUS OPMOINS OPOU
%token OPMULT OPMOD OPDIV OPET
%token OPNON
%token OPPT
/* Unite lexicale particuliere qui represente la fin du fichier */
%token FIN

/* Declarations des regles d'associative et de priorite pour les operateurs */
/* La priorite est croissante de haut en bas */
/* Associatif a droite */
%right ASSIGN /* Priorite la plus faible */
/* Non associatif */
%nonassoc OPINF OPSUP OPINFEG OPSUPEG OPEG OPNONEG
/* Associatif a gauche */
%left OPPLUS OPMOINS OPOU
%left OPMULT OPMOD OPDIV OPET
%right OPNON
%left OPPT PAROUV CROOUV /* Priorite la plus forte */

/* Type renvoye pour le nom terminal fichier */
%type <unit> fichier
%type <int> variables

/* Le non terminal fichier est l'axiome */
%start fichier

%% /* Regles de productions */

fichier : importer programme FIN { (print_endline "fichier : programme FIN");(print_string "Nombre de fonctions : ");(print_int !nbrFonctions);(print_newline());(print_string "Nombre de Méthodes:");(print_int $2);(print_newline()) }

programme : /* Lambda, mot vide */ { (nbrFonctions := 0); (print_endline "programme : /* Lambda, mot vide */");0 }
          | fonction programme { (nbrFonctions := !nbrFonctions + 1);(print_endline "programme : fonction programme");($1+$2) }

typeStruct : typeBase declTab { (print_endline "typeStruct : typeBase declTab") }

typeBase : INT { (print_endline "typeBase : INT") }
         | FLOAT { (print_endline "typeBase : FLOAT") }
         | BOOL { (print_endline "typeBase : BOOL") }
         | CHAR { (print_endline "typeBase : CHAR") }
         | STRING { (print_endline "typeBase : STRING") }
         | TYPEIDENT { (print_endline "typeBase : TYPEIDENT") }

declTab : /* Lambda, mot vide */ { (print_endline "declTab : /* Lambda, mot vide */") }
        | CROOUV CROFER { (print_endline "declTab : CROOUV CROFER") }

fonction : entete bloc  { (print_endline "fonction : entete bloc");(print_string "nb de bloc: ");(print_int $2);(print_newline ());$1 }

entete : typeStruct IDENT PAROUV parsFormels PARFER { (print_endline "entete : typeStruct IDENT PAROUV parsFormels PARFER");0 }
       | VOID IDENT PAROUV parsFormels PARFER { (print_endline "entete : VOID IDENT PAROUV parsFormels PARFER");1 }

parsFormels : /* Lambda, mot vide */ { (print_endline "parsFormels : /* Lambda, mot vide */") }
            | typeStruct IDENT suiteParsFormels { (print_endline "parsFormels : typeStruct IDENT suiteParsFormels") }

suiteParsFormels : /* Lambda, mot vide */ { (print_endline "suiteParsFormels : /* Lambda, mot vide */") }
                 | VIRG typeStruct IDENT suiteParsFormels { (print_endline "suiteParsFormels : VIRG typeStruct IDENT suiteParsFormels") }

bloc : ACCOUV /* $1 */ variables /* $2 */ instructions /* $3 */ ACCFER /* $4 */
     {
	(print_endline "bloc : ACCOUV variables instructions ACCFER");
	(print_string "Nombre de variables = ");
	(print_int $2);
	(print_newline ());
	(print_string "Nombre d'instructions = ");
	(print_int $3);
	(print_newline ());
	(1+$3)
	}

variables : /* Lambda, mot vide */
	  {
		(print_endline "variables : /* Lambda, mot vide */");
		0
		}
          | variable /* $1 */ variables /* $2 */
	  {
		(print_endline "variables : variable variables");
		($2 + 1)
		}

variable : typeStruct IDENT PTVIRG { (print_endline "variable : typeStruct IDENT PTVIRG") }

/* FAIT! : Completer pour decrire une liste d'instructions eventuellement vide */
instructions : {(print_endline "variables : /* Lambda, mot vide */");0}|instruction instructions{ (print_endline "instructions : instruction");($1+$2) }

/* A FAIRE : Completer pour ajouter les autres formes d'instructions */
instruction : expression PTVIRG { (print_endline "instruction : expression PTVIRG");0 }
							| RETOUR expression PTVIRG  { (print_endline "instruction : RETURN expression PTVIRG");0 }
							|SI PAROUV expression PARFER bloc blocs{(print_endline "instruction : SI PAROUV expression PARFER bloc blocs");($5+$6)}
							|TANTQUE PAROUV expression PARFER bloc{(print_endline "instruction : TANTQUE PAROUV expression PARFER bloc");$5}

blocs : {0}|SINON bloc{$2}

importer :{}| IMPORT aimport PTVIRG {(print_endline "importer : IMPORT aimport");}

aimport : finimport{} | IDENT OPPT suiteimport{}

finimport : TYPEIDENT{}| OPMULT {}

suiteimport : finimport {}| IDENT OPPT suiteimport{}

/* A FAIRE : Completer pour ajouter les autres formes d'expressions */
expression : boucleun expressions bouclebin {}

bouclebin : {} | binaire expression {}

boucleun : {} | unaire boucleun {}

expressions : ENTIER {} | FLOTTANT {} | CARACTERE {} | BOOLEEN {}| VIDE {}| NOUVEAU IDENT exp {} | exp2 suff {}

exp :PAROUV PARFER {} | CROOUV expression CROFER {}

exp2 : IDENT {} | PAROUV expression PARFER {}

suff : { } | suffixe suff {}
 /* expression :  ENTIER { (print_endline "expression : ENTIER") } 
	   | expression OPPLUS expression {(print_endline "expression : expression OPPLUS expression")}
	   
	   | expression OPMULT expression {}
	   
	   | OPPLUS expression %prec OPNON {}  */

unaire : PAROUV typeStruct PARFER {(print_endline "unaire : test")} 
				| OPPLUS {}
				| OPMOINS {}
				| OPNON {}

binaire : ASSIGN {(print_endline "binaire : ASSIGN")}
				| OPPT {}
				| OPPLUS {}
				| OPMOINS {}
				| OPMULT {}
				| OPDIV {}
				| OPMOD {}
				| OPOU {}
				| OPET {}
				| OPEG {}
				| OPNONEG {}
				| OPINF {}
				| OPSUP {}
				| OPINFEG {}
				| OPSUPEG {}

suffixe : PAROUV sufform PARFER {}
					| CROOUV expression CROFER {}

sufform : {} | expression sufforms {}

sufforms : {} | VIRG expression sufforms {}
%%
