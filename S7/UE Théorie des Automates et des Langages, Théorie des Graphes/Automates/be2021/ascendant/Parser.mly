%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_MODEL
%token UL_ACCOUV UL_ACCFER
%token UL_BLOCK
%token UL_SYSTEM

/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT
%token <float> UL_FLOAT

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> modele

/* Le non terminal document est l'axiome */
%start modele

%% /* Regles de productions */

modele : UL_MODEL UL_IDENT UL_ACCOUV boucle UL_ACCFER UL_FIN { (print_endline "modele : UL_MODEL IDENT { ... } UL_FIN ") }

boucle : 
         | bloc boucle
         | systeme boucle
         |flot boucle

bloc : UL_BLOCK UL_IDENT param UL_PV {}

system : UL_SYSTEM UL_IDENT param UL_ACCOUV boucle UL_ACCFER {}

param : UL_PAROUV ports UL_PARFER

ports : Port
        | Port UL_VIRG ports


flot : UL_FLOW UL_IDENT UL_FROM opIdent UL_ident UL_TO opIdent2 UL_PV

opIdent : 
        | UL_IDENT UL_POINT

opIdent2 : 
        | boucleIdent

boucleIdent : opIdent UL_ident 
            | opIdent UL_ident UP_VIRG boucleident 

%%





PRENDRE LE DIAGRAMME DE CONWAY ET ÉCRIRE LES BOUCLES ETC AVEC LES UL_ PRECEDENTS 