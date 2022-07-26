/* Imports. */

%{

open Type
open Ast.AstSyntax
%}


%token <int> ENTIER
%token <string> ID
%token RETURN
%token PV
%token AO
%token AF
%token PF
%token PO
%token EQUAL
%token CONST
%token PRINT
%token IF
%token ELSE
%token WHILE
%token BOOL
%token INT
%token RAT
%token CALL 
%token CO
%token CF
%token SLASH
%token NUM
%token DENOM
%token TRUE
%token FALSE
%token PLUS
%token ETOILE
%token INF
%token EOF
%token NEW
%token NULL
%token ADRESSE
%token TYPEDEF
%token <string> TID
%token POINT
%token STRUCT

(* Type de l'attribut synthétisé des non-terminaux *)
%type <programme> prog
%type <instruction list> bloc
%type <fonction> fonc
%type <instruction list> is
%type <instruction> i
%type <typ> typ
%type <(typ*string) list> dp
%type <expression> e 
%type <expression list> cp
%type <affectable> a
%type <typedef> td
%type <typedef list> ltds

(* Type et définition de l'axiome *)
%start <Ast.AstSyntax.programme> main

%%

main : lfi = prog EOF     {lfi}

prog :
| deft = ltds lf = fonc  lfi = prog   {let (Programme ([],lf1,li))=lfi in (Programme (deft,lf::lf1,li))}
| ID li = bloc            {Programme ([],[],li)}

td :
| TYPEDEF n=TID EQUAL t=typ PV     {Deftype (n,t)}

ltds :
|                           {[]}
| deft=td ldeft=ltds         {deft::ldeft}

fonc : t=typ n=ID PO p=dp PF AO li=is AF {Fonction(t,n,p,li)}

bloc : AO li = is AF      {li}

is :
|                         {[]}
| i1=i li=is              {i1::li}

i :
| t=typ n=ID EQUAL e1=e PV          {Declaration (t,n,e1)}
| CONST n=ID EQUAL e=ENTIER PV      {Constante (n,e)}
| PRINT e1=e PV                     {Affichage (e1)}
| IF exp=e li1=bloc ELSE li2=bloc   {Conditionnelle (exp,li1,li2)}
| WHILE exp=e li=bloc               {TantQue (exp,li)}
| RETURN exp=e PV                   {Retour (exp)}
| aff=a EQUAL exp=e PV              {Affectation (aff,exp)}
| aff=a PLUS EQUAL exp=e PV         {AssignationAdd (aff,exp)}
| deft=td                           {Typedef (deft)}

a :
| n=ID                        {Ident n}
| PO ETOILE aff=a PF          {Dereference (aff)}
| PO aff=a POINT n=ID PF      {Acces(aff,n)}

dp :
|                         {[]}
| t=typ n=ID lp=dp        {(t,n)::lp}

typ :
| BOOL                  {Bool}
| INT                   {Int}
| RAT                   {Rat}
| t=typ ETOILE          {Pointeur (t)}
| n=TID                 {TypeNomme n}
| STRUCT AO ldp=dp AF   {Enregistrement ldp}

e : 
| CALL n=ID PO lp=cp PF   {AppelFonction (n,lp)}
| CO e1=e SLASH e2=e CF   {Binaire(Fraction,e1,e2)}
| TRUE                    {Booleen true}
| FALSE                   {Booleen false}
| e=ENTIER                {Entier e}
| NUM e1=e                {Unaire(Numerateur,e1)}
| DENOM e1=e              {Unaire(Denominateur,e1)}
| PO e1=e PLUS e2=e PF    {Binaire (Plus,e1,e2)}
| PO e1=e ETOILE e2=e PF  {Binaire (Mult,e1,e2)}
| PO e1=e EQUAL e2=e PF   {Binaire (Equ,e1,e2)}
| PO e1=e INF e2=e PF     {Binaire (Inf,e1,e2)}
| PO exp=e PF             {exp}
| aff=a                   {Affect (aff)}
| NULL                    {Null}
| PO NEW t=typ PF         {New (t)}
| ADRESSE n=ID            {Adresse (n)}
| AO lcp=cp AF            {DefEnregistrement lcp}

cp :
|               {[]}
| e1=e le=cp    {e1::le}

