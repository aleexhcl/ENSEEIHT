open Type
open Ast.AstSyntax

(* Exceptions pour la gestion des identificateurs *)
exception DoubleDeclaration of string 
exception IdentifiantNonDeclare of string 
exception MauvaiseUtilisationIdentifiant of string 
exception MauvaiseUtilisationDefinitionType of string
exception TypeNonDeclare of unit 

(* Exceptions pour le typage *)
(* Le premier type est le type réel, le second est le type attendu *)
exception TypeInattendu of typ * typ
exception TypesParametresInattendus of typ list * typ list
exception TypeBinaireInattendu of binaire * typ * typ (* les types sont les types réels non compatible avec les signatures connues de l'opérateur *)
exception TypePointeurAttendu of typ (* le type attendu est un pointeur et non le type renvoyé par l'erreur*)
exception TypeAssignationAttendu of typ (*le type attendu est Int ou Rat pour une assignation d'addition *)