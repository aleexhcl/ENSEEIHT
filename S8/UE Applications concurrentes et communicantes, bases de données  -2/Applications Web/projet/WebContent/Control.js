/**
 * 
 */
 
 $(document).ready(function() {
	loadMain();
});

var profilCur;

function loadMain() {
	$("#Main").load("Main.html", function() {
		$("#BTInscriptionPseudo").click(function() {
			loadInscription0(); 
		});
		$("#BTConnexion").click(function() {
			profil = {};
			profil.pseudo=$("#pseudo").val();
			profil.motdepasse=$("#mdp").val();
			// check le mdp ? 
			p = invokeGet("rest/checkConnexion", profil, "connexion impossible", function(response){
				p = response;
				if (p==null) return; 
				profilCur = p;
				loadProfil(); 
			});
		});
	});
}

function loadInscription0() {
	$("#Main").load("inscription0.html", function() {
		$("#BTValInscriptionPseudo").click(function() {
			profil = {};
			profil.pseudo=$("#pseudo").val();
			profil.motdepasse=$("#mdp").val();
			// check le pseudo ? 
			//ok = invokeGet("rest/checkPseudo", pseudo, "pseudo deja existant", function(response){
				//ok = response;
				//if (!ok) return; 
			    invokePost("rest/creationProfil", profil, "creation profil ok", "creation profil failed");
				profilCur = profil; 
				profilCur.id = profil.id; 
				loadInscriptionDonnees1(); 
			//});
		});
	});
}

function loadInscriptionDonnees1() {
	$("#Main").load("inscription1.html", function() {
		$("#BTValInscriptionDonnees1").click(function() {
			identite = {};
			identite.nom=$("#nom").val();
			identite.prenom=$("#prenom").val();
			identite.nationnalite=$("#nationalite").val();
			identite.surnom=$("#surnom").val();
			identite.langues=$("#langues option:selected").text();
			identite.sexe=$("#sexe option:selected").text();
			identite.age=$("#age").val();
			
			invokePost("rest/creationId", identite, "id ok", "id failed");
			profilCur.identite = identite; 
			
			loadInscriptionDonnees2();
		});
	});
}

function loadInscriptionDonnees2() {
	$("#Main").load("inscription2.html", function() {
		$("#BTValInscriptionDonnees2").click(function() {
			
			coordonnees = {};
			coordonnees.adresse=$("#adresse").val();
			coordonnees.facebook=$("#facebook").val();
			coordonnees.insta=$("#insta").val();
			coordonnees.numero=$("#numero").val();
			
			invokePost("rest/creationCoord", coordonnees, "coord ok", "coord failed");
			profilCur.coordonnees = coordonnees; 
			
			loadInscriptionDonnees3();
		});
	});
}

function loadInscriptionDonnees3() {
	$("#ShowMessage").empty();
	$("#Main").load("inscription3.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			morale = {};
			morale.temperament=$("#temperament option:selected").text();
			morale.habitude=$("#habitude option:selected").text();
			morale.valeurs=$("#valeurs option:selected").text();
			morale.talents=$("#talents option:selected").text();
			morale.animaux=$("#animaux option:selected").text();
			
			invokePost("rest/creationMorale", morale, "morale ok", "morale failed");
			profilCur.caractMorale = morale; 
			
			loadInscriptionDonnees4();
		});
	});
}

function loadInscriptionDonnees4() {
	$("#Main").load("inscription4.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			physique = {};
			physique.taille=$("#taille").val();
			physique.coul_cheveux=$("#coul_cheveux option:selected").text();
			physique.longueur_cheveux=$("#longueur_cheveux").text(); 
			physique.yeux=$("#yeux option:selected").text();
			physique.vetement=$("#vetement option:selected").text();
			physique.voix=$("#voix option:selected").text();
			physique.forme=$("#forme option:selected").text();
			
			invokePost("rest/creationPhysique", physique, "physique ok", "physique failed");
			profilCur.caractPhysique = physique;
			
			loadInscriptionDonnees5();
		});
	});
}

var preferences = {};

function loadInscriptionDonnees5() {
	$("#Main").load("inscription5.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			physiquepref = {};
			physiquepref.taille=$("#taille option:selected").text();
			physiquepref.coul_cheveux=$("#coul_cheveux option:selected").text();
			physiquepref.longueur_cheveux=$("#longueur_cheveux option:selected").text();
			physiquepref.yeux=$("#yeux option:selected").text();
			physiquepref.vetement=$("#vetement option:selected").text();
			physiquepref.voix=$("#voix option:selected").text();
			physiquepref.forme=$("#forme option:selected").text();
			
			invokePost("rest/creationPhysique", physiquepref, "physiquepref ok", "physiquepref failed");
			
			preferences.caractPhysiques = physiquepref; 
			
			loadInscriptionDonnees6();
		});
	});
}

function loadInscriptionDonnees6() {
	$("#Main").load("inscription6.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			moralepref = {};
			moralepref.temperament=$("#temperament option:selected").text();
			moralepref.habitude=$("#habitude option:selected").text();
			moralepref.valeurs=$("#valeurs option:selected").text();
			moralepref.talents=$("#talents option:selected").text();
			moralepref.animaux=$("#animaux option:selected").text();
			invokePost("rest/creationMorale", moralepref, "moralepref ok", "moralepref failed");
			
			preferences.caractMorales = moralepref;
			
			invokePost("rest/creationPref", preferences, "pref ok", "pref failed");
			profilCur.pref = preferences; 
			
			invokePost("rest/ajoutProfil", profilCur, "inscription ok", "inscription failed");
			loadProfil();
		});
	});
}

function loadProfil() {
	$("#Main").load("Profil.html", function() {
		$("#BTAfficherProfil").click(function() {
			loadAfficherProfil();
		});
		$("#BTModifProfil").click(function() {
			loadModifierProfil();
		});
		$("#BTRechercheMatch").click(function() {
			loadRecherche();
		});
		$("#BTListeMatch").click(function() {
			loadListe();
		});
		$("#BTDeconnexion").click(function() {
			loadMain();
		});
	});
}

function loadAfficherProfil() {
	$("#Main").load("AfficherProfil.html", function() {
		var pseudo, id, coord, morale, phy;
		pseudo = profilCur.pseudo; 
		$("#Pseudo").append("Pseudo : "+pseudo); 
		identite = profilCur.identite; 
		$("#Identite").append("Nom : "+identite.nom+"<br> Prénom : "+identite.prenom+ "<br> Nationalité : "+identite.nationnalite
				+"<br> Surnom : "+identite.surnom+"<br> Langue : "+identite.langues+"<br> Sexe : "+identite.sexe+"<br> Age : "+parseInt(identite.age)); 
		coord = profilCur.coordonnees;
		$("#Coordonnees").append("Adresse : "+coord.adresse+"<br> Numéro : "+coord.numero+"<br> Insta : "+coord.insta+"<br> Facebook : "+coord.facebook);
		morale = profilCur.caractMorale;
		$("#Morale").append("Tempérament : "+morale.temperament+"<br> Habitude : "+morale.habitude+"<br> Valeur : "+morale.valeurs+"<br> Talent : "+morale.talents+"<br> Animaux : "+morale.animaux);
		phy = profilCur.caractPhysique;
		$("#Physique").append("Taille : "+parseInt(phy.taille)+"<br> Couleur de cheveux : "+phy.coul_cheveux+"<br> Longueur de cheveux : "+phy.longueur_cheveux+"<br> Couleur de yeux : "+phy.yeux
				+"<br> Style vestimentaire : "+phy.vetement+"<br> Voix : "+phy.voix+"<br> Corpulence : "+phy.forme); 
		morale = profilCur.pref.caractMorales;
		$("#MoralePref").append("Tempérament : "+morale.temperament+"<br> Habitude : "+morale.habitude+"<br> Valeur : "+morale.valeurs+"<br> Talent : "+morale.talents+"<br> Animaux : "+morale.animaux);
		phy = profilCur.pref.caractPhysiques;
		$("#PhysiquePref").append("Taille : "+parseInt(phy.taille)+"<br> Couleur de cheveux : "+phy.coul_cheveux+"<br> Longueur de cheveux : "+phy.longueur_cheveux+"<br> Couleur de yeux : "+phy.yeux
				+"<br> Style vestimentaire : "+phy.vetement+"<br> Voix : "+phy.voix+"<br> Corpulence : "+phy.forme); 
		
		
		$("#BTModifProfil").click(function() {
			loadModifierProfil();
		});
		$("#BTProfil").click(function() {
			loadProfil();
		});
	});
}

function loadModifierProfil() {
	$("#Main").load("ModifierProfil.html", function() {
		$("#BTModifIdentite").click(function() {
			loadModifDonnees1();
		});
		$("#BTModifCoordonnées").click(function() {
			loadModifDonnees2();
		});
		$("#BTModifMorale").click(function() {
			loadModifDonnees3();
		});
		$("#BTModifPhysique").click(function() {
			loadModifDonnees4();
		});
		$("#BTModifPref").click(function() {
			loadModifDonnees5();
		});
		$("#BTProfil").click(function() {
			loadProfil();
		});
	});
}

function loadModifDonnees1() {
	$("#Main").load("inscription1.html", function() {
		$("#BTValInscriptionDonnees1").click(function() {
			identite = {};
			identite.nom=$("#nom").val();
			identite.prenom=$("#prenom").val();
			identite.nationnalite=$("#nationalite").val();
			identite.surnom=$("#surnom").val();
			identite.langues=$("#langues option:selected").val();
			identite.sexe=$("#sexe option:selected").val();
			identite.age=$("#age").val();
			
			invokePost("rest/creationId", identite, "id ok", "id failed");
			profilCur.identite = identite; 
			invokePost("rest/ajoutProfil", profilCur, "modif ok", "modif failed");
			loadProfil();
		});
	});
}

function loadModifDonnees2() {
	$("#Main").load("inscription2.html", function() {
		$("#BTValInscriptionDonnees2").click(function() {
			
			coordonnees = {};
			coordonnees.adresse=$("#adresse").val();
			coordonnees.facebook=$("#facebook").val();
			coordonnees.insta=$("#insta").val;
			coordonnees.numero=$("#numero").val();
			
			invokePost("rest/creationCoord", coordonnees, "coord ok", "coord failed");
			profilCur.coordonnees = coordonnees; 
			invokePost("rest/ajoutProfil", profilCur, "modif ok", "modif failed");
			loadProfil();
		});
	});
}

function loadModifDonnees3() {
	$("#ShowMessage").empty();
	$("#Main").load("inscription3.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			morale = {};
			morale.temperament=$("#temperament option:selected").val();
			morale.habitude=$("#habitude option:selected").val();
			morale.valeurs=$("#valeurs option:selected").val();
			morale.talents=$("#talents option:selected").val();
			morale.animaux=$("#animaux option:selected").val();
			
			invokePost("rest/creationMorale", morale, "morale ok", "morale failed");
			profilCur.caractMorale = morale; 
			invokePost("rest/ajoutProfil", profilCur, "modif ok", "modif failed");
			loadProfil();
		});
	});
}

function loadModifDonnees4() {
	$("#Main").load("inscription4.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			physique = {};
			physique.taille=$("#taille option:selected").val();
			physique.coul_cheveux=$("#coul_cheveux option:selected").val();
			physique.longueur_cheveux=$("#longueur_cheveux").val(); 
			physique.yeux=$("#yeux option:selected").val();
			physique.vetement=$("#vetement option:selected").val();
			physique.voix=$("#voix option:selected").val();
			physique.forme=$("#forme option:selected").val();
			
			invokePost("rest/creationPhysique", physique, "physique ok", "physique failed");
			profilCur.caractPhysique = physique;
			invokePost("rest/ajoutProfil", profilCur, "modif ok", "modif failed");
			loadProfil();
		});
	});
}

function loadModifDonnees5() {
	$("#Main").load("inscription5.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			physiquepref = {};
			physiquepref.taille=$("#taillepref option:selected").val();
			physiquepref.coul_cheveux=$("#coul_cheveuxpref option:selected").val();
			physiquepref.longueur_cheveux=$("#longueur_cheveuxpref option:selected").val();
			physiquepref.yeux=$("#yeuxpref option:selected").val();
			physiquepref.vetement=$("#vetementpref option:selected").val();
			physiquepref.voix=$("#voixpref option:selected").val();
			physiquepref.forme=$("#formepref option:selected").val();
			
			invokePost("rest/creationPhysique", physiquepref, "physiquepref ok", "physiquepref failed");
			
			preferences.caractPhysiques = physiquepref; 
			
			loadModifDonnees6();
		});
	});
}

function loadModifDonnees6() {
	$("#Main").load("inscription6.html", function() {
		$("#BTValInscriptionDonnees").click(function() {
			
			moralepref = {};
			moralepref.temperament=$("#temperamentpref option:selected").val();
			moralepref.habitude=$("#habitudepref option:selected").val();
			moralepref.valeurs=$("#valeurspref option:selected").val();
			moralepref.talents=$("#talentspref option:selected").val();
			moralepref.animaux=$("#animauxpref option:selected").val();
			invokePost("rest/creationMorale", moralepref, "moralepref ok", "moralepref failed");
			
			preferences.caractMorales = moralepref;
			
			invokePost("rest/creationPref", preferences, "pref ok", "pref failed");
			profilCur.pref = preferences; 
			
			invokePost("rest/ajoutProfil", profilCur, "modif ok", "modif failed");
			loadProfil();
		});
	});
}

function loadRecherche() {
	$("#Main").load("Recherche.html", function() {
		var listMatchPhysique, listMatchMorale;
		
		invokeGet("rest/classementMatchPhysique", profilCur, "listemorale failed", function(response){
			listMatchPhysique = response; 
			if (listMatchPhysique == null) return;
			for(var i=0; i<listMatchPhysique.length; i++) {
				var profilPhy = listMatchPhysique[i];
				$("#ListMatchPhy").append("<input type='radio' name='PersonId' value='"+profilPhy.pseudo+"'>"+profilPhy.identite+"<br>");
			}
		});
		invokeGet("rest/classementMatchMorale", profilCur, "listemorale failed", function(response){
			listMatchMorale = response; 
			if (listMatchMorale == null) return;
			for(var i=0; i<listMatchMorale.length; i++) {
				var profilMor = listMatchMorale[i];
				$("#ListMatchMor").append("<input type='radio' name='PersonId' value='"+profilMor.pseudo+"'>"+profilMor.identite+"<br>");
			}
		});
		$("#BTConfirmer").click(function() {
			// ajouter la personne selectionner aux matchs du profil 

			profilCur.matchs.push(("input[name='PersonId']:checked").val());
			invokePost("rest/ajoutMatch", profilCur.id, "ajout match ok", "ajout match failed");
			loadListe();
		});
		
	});
}

function loadListe() {
	$("#Main").load("Liste.html", function() {
		invokeGet("rest/getMatch", profilCur, "listemorale failed", function(response){
			listMatch = response;
			if (listMatch == null) return;
			for(var i=0; i<listMatch.length; i++) {
				var profil = listMatch[i];
				$("#ListMatch").append(profil.pseudo+"<br>");
			}
		});
		$("#BTConfirmer").click(function() {
			loadProfil();
		});
	});
}

function loadDeconnexion() {
	//profilCur = {};
	loadMain();
}

function invokePost(url, data, successMsg, failureMsg) {
	jQuery.ajax({
	    url: url,
	    type: "POST",
	    data: JSON.stringify(data),
	    dataType: "json",
	    contentType: "application/json; charset=utf-8",
	    success: function (response) {
	    	$("#ShowMessage").text(successMsg);
	    },
	    error: function (response) {
	    	$("#ShowMessage").text(failureMsg);
	    }
	});
}
function invokeGet(url, failureMsg, responseHandler) {
	jQuery.ajax({
	    url: url,
	    type: "GET",
	    success: responseHandler,
	    error: function (response) {
	    	$("#ShowMessage").text(failureMsg);
	    }
	});
}
function invokeGet(url, data, failureMsg, responseHandler) {
	jQuery.ajax({
	    url: url,
	    type: "GET",
	    data: JSON.stringify(data),
	    dataType: "json",
	    success: responseHandler,
	    error: function (response) {
	    	$("#ShowMessage").text(failureMsg);
	    }
	});
}