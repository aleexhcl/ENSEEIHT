%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_MODEL

%token UL_ACCOUV UL_ACCFER
%token UL_PAROUV UL_PARFER 
%token UL_CROOUV UL_CROFER

%token UL_SYS UL_BLOCK UL_FLOW
%token UL_FROM UL_TO UL_IN UL_OUT 
%token UL_INT UL_FLOAT UL_BOOL
%token UL_PTVIRG UL_VIRG UL_PT UL_DXPT

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT
%token <string> UL_ident 
%token <int> UL_ENTIER  

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> modele

/* Le non terminal document est l'axiome */
%start modele

%% /* Regles de productions */

modele : UL_MODEL UL_IDENT UL_ACCOUV suite_modele UL_ACCFER UL_FIN { (print_endline "modele : UL_MODEL IDENT { suite_modele } UL_FIN ") }

suite_modele : /*Rien*/ { (print_endline "suite_modele : Rien ") }
              | bloc suite_modele { (print_endline "suite_modele : bloc suite_modele ") }
              | systeme suite_modele { (print_endline "suite_modele : systeme suite_modele ") }
              | flot suite_modele { (print_endline "suite_modele : flot suite_modele ") }

bloc : UL_BLOCK UL_IDENT parametres UL_PTVIRG { (print_endline "bloc : UL_BLOCK UL_IDENT parametres UL_PTVIRG ") }

systeme : UL_SYS UL_IDENT parametres UL_ACCOUV suite_modele UL_ACCFER { (print_endline "systeme : UL_SYS UL_IDENT parametres UL_ACCOUV suite_modele UL_ACCFER ") }

parametres : UL_PAROUV port suite_parametres UL_PARFER { (print_endline "parametres : UL_PAROUV port suite_parametres UL_PARFER ") }

suite_parametres : /*Rien*/ { (print_endline "suite_parametres : Rien ") }
                  | UL_VIRG port suite_parametres { (print_endline "suite_parametres : UL_VIRG port suite_parametres ") }

port : UL_ident UL_DXPT suite_port types { (print_endline "port : UL_ident UL_DXPT suite_port types ") }

suite_port : UL_IN { (print_endline "suite_port : UL_IN ") }
            | UL_OUT { (print_endline "suite_port : UL_OUT ") }

types : debut_type suite_type { (print_endline "types : debut_type suite_type ") }

debut_type : UL_INT { (print_endline "debut_type : UL_INT ") }
            | UL_FLOAT { (print_endline "debut_type : UL_FLOAT ") }
            | UL_BOOL { (print_endline "debut_type : UL_BOOL ") }

suite_type : /*Rien*/ { (print_endline "suite_type : Rien ") }
            | UL_CROOUV UL_ENTIER suite_entier UL_CROFER { (print_endline "suite_type : UL_CROOUV UL_ENTIER suite_entier UL_CROFER ") }

suite_entier : /*Rien*/ { (print_endline "suite_entier : Rien ") }
              | UL_VIRG UL_ENTIER suite_entier { (print_endline "suite_entier : UL_VIRG UL_ENTIER suite_entier ") }

flot : UL_FLOW UL_ident UL_FROM if_flot UL_ident UL_TO suite_flot UL_PTVIRG { (print_endline "flot : UL_FLOW UL_ident UL_FROM if_flot UL_ident UL_TO suite_flow UL_PTVIRG ") }

if_flot : /*Rien*/ { (print_endline "if_flot : Rien ") }
          | UL_IDENT UL_PT { (print_endline "if_flot : UL_IDENT UL_PT ") }

suite_flot : /*Rien*/ { (print_endline "suite_flot : Rien ") }
            | if_if_flot { (print_endline "suite_flot : if_if_flot ") }

if_if_flot : if_flot UL_ident suite_suite_flot { (print_endline "if_if_flot : if_flot UL_ident suite_suite_flot ") }

suite_suite_flot : /*Rien*/ { (print_endline "suite_suite_flot : Rien ") }
                  | UL_VIRG if_if_flot { (print_endline "suite_suite_flot : UL_VIRG if_if_flot ") }
%%
