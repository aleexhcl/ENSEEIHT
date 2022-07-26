(* Module de la passe de gestion des identifiants *)
module PasseTdsRat : Passe.Passe with type t1 = Ast.AstSyntax.programme and type t2 = Ast.AstTds.programme =
struct

  open Tds
  open Exceptions
  open PrinterAst
  open Ast
  open AstTds

  type t1 = Ast.AstSyntax.programme
  type t2 = Ast.AstTds.programme

(* nom_to_type : tds -> Typ -> Typ *)
(* Paramètre tds : la table des symboles courante *)
(* Parametre t : type à convertir en type réel *)
(* change le nom d'un type nommé en le type correspondant si c'est un type nommé,
renvoie le type donné sinon *)
let nom_to_type tds t = 
match t with 
            | Type.TypeNomme ty -> 
              begin match chercherGlobalement tds ty with
                | Some ia -> 
                  begin match info_ast_to_info ia with 
                    | InfoVar (_,k,_,_) -> k
                    | _ -> raise (TypeNonDeclare ())
                  end
                | None -> raise (TypeNonDeclare ())
              end
            | _ -> t

(* analyse_tds_typedef : tds -> AstSyntax.typedef -> AstTds.typedef *)
(* Paramètre tds : la table des symboles courante 
             td : type à définir *)
(* analyse de la déclaration d'un type nommé *)
(* erreur si l'identifiant existe déjà dans la tds *)
let rec analyse_tds_typedef tds td = 
  match td with 
  | AstSyntax.Deftype (n,t) -> 
    begin match chercherGlobalement tds n with 
      | None -> let nt = nom_to_type tds t in
                let info = InfoVar(n,nt,0,"") in let ia = info_to_info_ast info in
                ajouter tds n ia ;
                let _ = begin match t with 
                        | Type.Enregistrement l -> let lt, ln = List.split l in 
                          ignore (
                              List.map2 (fun t n -> begin match chercherGlobalement tds n with 
                                                    | None -> let nt = nom_to_type tds t in 
                                                        let info = InfoVar(n,nt,0,"") in 
                                                        ajouter tds n (info_to_info_ast info)
                                                    | Some _ -> raise (DoubleDeclaration n)
                                                    end )
                               lt ln )
                          | _ -> () 
                        end in 
                Deftype(ia,nt) 
      | Some _ -> raise (MauvaiseUtilisationDefinitionType n)
    end   

(* analyse_tds_affectable : tds -> bool -> AstSyntax.affectable -> AstTds.affectable *)
(* Paramètre tds : la table des symboles courante *)
(* Parametre affectable : vrai si l'opération à faire est une affectation *)
(* Paramètre a : l'affectable à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'affectable
en un affectable de type AstTds.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_affectable tds affectation a =
  match a with
  | AstSyntax.Ident s -> 
  begin match chercherLocalement tds s with 
  (* L'identifiant n'est pas trouvé dans la tds locale. *) 
    | None -> 
      begin match chercherGlobalement tds s  with
          (* L'identifiant n'est pas trouvé dans la tds globale. *) 
          |None -> raise (IdentifiantNonDeclare s)
          (* L'identifiant est trouvé dans la tds globale, 
          il a donc déjà été déclaré. L'information associée est récupérée. *)
          |Some infoast -> 
          begin match info_ast_to_info infoast with
            (* s'il s'agit de l'information d'une constante, une erreur est levée 
            lorsque l'opération initiale de l'analyse de l'affectable concerne une 
            affectation *)
            | InfoConst _ -> if affectation then raise (MauvaiseUtilisationIdentifiant s) 
                                else Ident(infoast)
            | InfoVar _ -> Ident(infoast)
            | _ -> raise (MauvaiseUtilisationIdentifiant s)
          end
      end
  (* L'identifiant est trouvé dans la tds globale, 
  il a donc déjà été déclaré. L'information associée est récupérée. *)
    | Some infoast -> 
      begin match info_ast_to_info infoast with
          | InfoConst _ -> if affectation then raise (MauvaiseUtilisationIdentifiant s)
                              else Ident(infoast)
          | InfoVar _ -> Ident(infoast)
          | _ -> raise (MauvaiseUtilisationIdentifiant s)
      end
  end
  (* analyse l'affectable et renvoie la dereference de l'affectable *)
  | AstSyntax.Dereference a -> let na = analyse_tds_affectable tds false a in 
                                Dereference na
  (* analyse de l'acces à un enregistrement *)
  | AstSyntax.Acces (a,n) -> begin match chercherLocalement tds n with 
                                          (* cherche si l'élément est le même dans la tds mere de la tds locale *)
                            | Some lia -> begin match chercherMere tds n with 
                                          | None -> let na = analyse_tds_affectable tds false a in 
                                                    Acces(na,lia)
                                          | Some gia -> if gia == lia then let na = analyse_tds_affectable tds false a in 
                                                                      Acces(na,gia) 
                                                        (* le champ de l'enregistrement est masqué par une variable locale *)
                                                        else raise (MauvaiseUtilisationIdentifiant n)
                                            end 
                            | None -> begin match chercherGlobalement tds n with 
                                          | None -> raise (MauvaiseUtilisationIdentifiant n)
                                          | Some gia -> let na = analyse_tds_affectable tds false a in 
                                                                      Acces(na,gia) 
                                      end 
                            end

(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_expression tds e = 
  match e with
    |AstSyntax.AppelFonction (s, el) ->
      begin
        match chercherGlobalement tds s with 
        |None -> raise (IdentifiantNonDeclare s)
        |Some f -> 
          begin match info_ast_to_info f with 
            | InfoFun(_,_,lt) -> if List.(length lt = length el) then
                            let nle = List.map (analyse_tds_expression tds) el  in
                            AppelFonction (f, nle)
                            else raise (MauvaiseUtilisationIdentifiant s)
            |_ -> raise (MauvaiseUtilisationIdentifiant s)
          end
      end
    |AstSyntax.Binaire (b,e1,e2) -> let ne1 = analyse_tds_expression tds e1 in 
                                    let ne2 = analyse_tds_expression tds e2 in
                                    Binaire(b,ne1,ne2)
    |AstSyntax.Unaire (b,e1) -> let ne1 = analyse_tds_expression tds e1 in 
                                    Unaire(b,ne1)
    |AstSyntax.Entier (i) -> Entier (i)
    |AstSyntax.Booleen (b) -> Booleen(b)
                        (* remplace les types nommés par leur type réel *)
    |AstSyntax.New t -> let nt = nom_to_type tds t in New nt
    |AstSyntax.Null -> Null
    |AstSyntax.Adresse s -> 
      begin match chercherLocalement tds s with
        | Some ia -> 
          begin match info_ast_to_info ia with
            | InfoVar _ -> Adresse ia
            | _ -> raise (MauvaiseUtilisationIdentifiant s)
          end
        | None -> 
          begin match chercherGlobalement tds s with 
            | Some ia -> 
              begin match info_ast_to_info ia with
                | InfoVar _ -> Adresse ia
                | _ -> raise (MauvaiseUtilisationIdentifiant s)
              end
            | None -> raise (IdentifiantNonDeclare s)
          end
      end
    |AstSyntax.Affect a -> let na = analyse_tds_affectable tds false a in
                           Affect na
    |AstSyntax.DefEnregistrement le -> let nle = List.map (analyse_tds_expression tds) le in
                              DefEnregistrement nle

(* analyse_tds_instruction : tds -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds i =
  match i with
  | AstSyntax.Declaration (t, n, e) -> 
      (* enregistrement des variables utilisées dans le type nommé dans la tds *)
      let _ = begin match t with 
        | Type.Enregistrement l -> let lt, ln = List.split l in 
                          ignore ( List.map2 (fun t n -> begin match chercherGlobalement tds n with 
                                                    | None -> let nt = nom_to_type tds t in
                                                        let info = InfoVar(n,nt,0,"") in 
                                                        ajouter tds n (info_to_info_ast info)
                                                    | Some _ -> raise (DoubleDeclaration n)
                                                    end)
                                    lt ln )
        | _ -> () 
                end in 
      (* remplace les types nommés par leur type réel *)
      let nty = nom_to_type tds t in 
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale, 
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *) 
            let ne = analyse_tds_expression tds e in
            (* Création de l'information associée à l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information 
            et l'expression remplacée par l'expression issue de l'analyse *)
            Declaration (nty, ia, ne) 
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale, 
            il a donc déjà été déclaré dans le bloc courant *) 
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (a,e) -> 
            (* Vérifie l'utilisation des identifiants dans l'affectable 
            et dans l'expression et obtention des affectable et expression 
            transformés*)
              let na = analyse_tds_affectable tds true a in 
              let ne = analyse_tds_expression tds e in
              (* Renvoie de la nouvelle affectation où l'affectable  et l'expression 
              ont été remplacé par l'affectable et l'expression issus des analyses *)
              Affectation (na,ne)
  | AstSyntax.Constante (n,v) -> 
      begin
        match chercherLocalement tds n with
        | None -> 
        (* L'identifiant n'est pas trouvé dans la tds locale, 
        il n'a donc pas été déclaré dans le bloc courant *)
        (* Ajout dans la tds de la constante *)
        ajouter tds n (info_to_info_ast (InfoConst (n,v))); 
        (* Suppression du info_to_info_ast info iud de déclaration des constantes devenu inutile *)
        Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale, 
          il a donc déjà été déclaré dans le bloc courant *) 
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e -> 
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) -> 
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) -> 
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds b in
      (* Renvoie la nouvelle structure de la boucle *)
      TantQue (nc, bast)
  | AstSyntax.Retour (e) -> 
      (* Analyse de l'expression *)
      let ne = analyse_tds_expression tds e in
      Retour (ne)
  | AstSyntax.AssignationAdd (a,e) -> 
      let na = analyse_tds_affectable tds true a and ne = analyse_tds_expression tds e in
      AssignationAdd (na, ne)
  | AstSyntax.Typedef (td) -> Typedef (analyse_tds_typedef tds td)

(* analyse_tds_bloc : tds -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc
en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds li =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale 
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc 
  Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc) li in
   nli

(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre maintds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li))  = 

  match chercherGlobalement maintds n with
  |None -> let tps,_ = List.split lp in 
          (* remplace les types nommés par leur type réel *)
          let modltps = List.map (nom_to_type maintds) tps in 
          let infof = InfoFun(n, Undefined, modltps) in
          let ia = info_to_info_ast infof in
          ajouter maintds n ia ;
          (* création de la tds de la fonction *)
          let tdsfille = creerTDSFille maintds in
          (* vérifie la déclaration et ajoute les paramètre à la tds de la fonction *)
          let nlp = List.map (fun (t,s) -> let info = InfoVar (s,Undefined, 0, "") in 
                                            begin match chercherLocalement tdsfille s with
                                            |None -> let ia = info_to_info_ast info in 
                                                    (* remplace les types nommés par leur type réel *)
                                                    let nt = nom_to_type maintds t in
                                                    ajouter tdsfille s ia ; (nt, ia) 
                                            |Some _ -> raise (DoubleDeclaration s)
                                            end )
                            lp in 
          let nli = analyse_tds_bloc tdsfille li in 
          let nt = nom_to_type maintds t in 
          Fonction(nt,ia,nlp,nli) 

  |Some ria ->
    begin match info_ast_to_info ria with 
      |InfoFun(_,_,l) -> let long = List.length l in 
          (* la signature de la fonction existe deja *)
          if long = List.length lp then raise (DoubleDeclaration n) 
          (* la signature de la fonction n'existe pas encore *)
          else let tps,_ = List.split lp in 
          let modltps = List.map (nom_to_type maintds) tps in 
          let nt = nom_to_type maintds t in
          modifier_type_fonction_info nt modltps ria ;
          let tdsfille = creerTDSFille maintds in
          let nlp = List.map (fun (t,s) -> let info = InfoVar (s,Undefined, 0, "") in 
                                            begin match chercherLocalement tdsfille s with
                                            |None -> let ia = info_to_info_ast info in 
                                                    let nt = nom_to_type maintds t in
                                                    ajouter tdsfille s ia ; (nt, ia) 
                                            |Some _ -> raise (DoubleDeclaration s)
                                            end )
                            lp in 
          let nli = analyse_tds_bloc tdsfille li in 
          Fonction(nt,ria,nlp,nli)
      | _ -> raise (MauvaiseUtilisationIdentifiant n)
    end 

(* analyser : AstSyntax.ast -> AstTds.ast *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.ast *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (deftypes, fonctions,prog)) =
  let tds = creerTDSMere () in
  let nt = List.map (analyse_tds_typedef tds) deftypes in 
  let nf = List.map (analyse_tds_fonction tds) fonctions in 
  let nb = analyse_tds_bloc tds prog in 
  Programme (nt,nf,nb)

end

