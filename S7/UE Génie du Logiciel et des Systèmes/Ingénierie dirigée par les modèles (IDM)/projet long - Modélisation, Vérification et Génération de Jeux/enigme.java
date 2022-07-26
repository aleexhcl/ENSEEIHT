package fr.n7.enigme;

import java.util.List;
import java.util.Scanner;
import fr.n7.game.*;
import fr.n7.game.impl.*;
import fr.n7.game.GameFactory;
import fr.n7.game.GamePackage;
import org.eclipse.emf.common.util.*;
import java.util.Map;

public class enigme {

	public static void main(String[] args) {
	
		GamePackage packageInstancepdl = GamePackage.eINSTANCE;
		GameFactory mF =GameFactory.eINSTANCE;
		
		Jeu jeu=mF.createJeu();
		jeu.setName("enigmes");
		Lieu lieu1 = mF.createLieu();
		lieu1.setName("Énigme");
		Lieu lieu2 = mF.createLieu();
		lieu2.setName("Succès");
		Lieu lieu3 = mF.createLieu();
		lieu3.setName("Échec");
		Joueur joueur = mF.createJoueur();
		joueur.setName("explorateur");
		Objet tentative = mF.createObjet();
		tentative.setName("Tentative");
		tentative.setQuantite(3);
		tentative.setTaille(1);
		ObjetPresent obnm = mF.createObjetPresent();
		obnm.setObjet(tentative);
		obnm.setNbPoss(3);
		joueur.getObjetsPossedes().add(obnm);
		Personne sphinx = mF.createPersonne();
		sphinx.setName("Sphinx");
		sphinx.setConditionVisible(null);
		sphinx.setObligatoire(false);
		
		Choix choix = mF.createChoix();
		choix.setName("Question");
		
		sphinx.getInteraction().add(choix);
		Action actionBonneReponse = mF.createAction();
		actionBonneReponse.setName("BonneReponse");
		choix.getActions().add(actionBonneReponse);
		Action actionMauvaiseReponse = mF.createAction();
		actionMauvaiseReponse.setName("MauvaiseReponse");
		choix.getActions().add(actionMauvaiseReponse);
		lieu1.getPersonnes().add(sphinx);
		Chemin cheminSucces=mF.createChemin();
		Connaissance reussite = mF.createConnaissance();
		Chemin cheminEchec=mF.createChemin();
		
		Condition conditionVisibleSucces = mF.createCondition();
		Disjonction disjSucces = mF.createDisjonction();
		ConditionCon conjSucces = mF.createConditionCon();
		conjSucces.setNegation(false);
		conjSucces.setConnaissance(reussite);
		conditionVisibleSucces.getDisjonctions().add(disjSucces);
		conditionVisibleSucces.getDisjonctions().get(0).getConjonctions().add(conjSucces);
		cheminSucces.setConditionVisible(conditionVisibleSucces);
		
		Condition conditionVisibleEchec = mF.createCondition();
		Disjonction disjEchec = mF.createDisjonction();
		ObjetPresent conjEchec = mF.createObjetPresent();
		conjEchec.setObjet(tentative);
		conjEchec.setNbPoss(0);
		conditionVisibleEchec.getDisjonctions().add(disjEchec);
		conditionVisibleEchec.getDisjonctions().get(0).getConjonctions().add(conjEchec);

		cheminEchec.setConditionVisible(conditionVisibleEchec);

		/*Condition svisible=mF.createCondition();
		svisible.getConnaissanceNecessaires().add(0, reussite);
		svisible.getObjetNecessaire().add(tentativespossibles);
		svisible.getNb().add(0);
		svisible.getOperateur().add(">");*/
		
		Scanner myObj = new Scanner(System.in);  // Create a Scanner object
	    System.out.println("Bienvenue devant le sphinx");
	    System.out.println("Nombre de tentatives : "+((ObjetPresent)joueur.getObjetsPossedes().get(0)).getNbPoss());
	    
		while(((ObjetPresent)joueur.getObjetsPossedes().get(0)).getNbPoss()>0) {
			joueur.setPosition(lieu1);
			
			for(Choix c: sphinx.getInteraction()) {
				System.out.println(c.getName());
			}
			
			System.out.println("Reponse: chiffre entre 0 et 0 correspondant au numéro de la Question");
		    int idAction = Integer.parseInt(myObj.nextLine());
		   
		    for (Action a : sphinx.getInteraction().get(idAction).getActions()) {
		    	System.out.println(a.getName());    
		    }
		    
		   int idReponse=Integer.parseInt(myObj.nextLine());
		   if (sphinx.getInteraction().get(idAction).getActions().get(idReponse).getName().contentEquals("MauvaiseReponse")) {
			   ((ObjetPresent) joueur.getObjetsPossedes().get(0)).setNbPoss(((ObjetPresent) joueur.getObjetsPossedes().get(0)).getNbPoss()-1);
			   if (((ObjetPresent) joueur.getObjetsPossedes().get(0)).getNbPoss()==0) {
				   joueur.setPosition(lieu3);
				   break;
			   }
		   }
		   
		   if (sphinx.getInteraction().get(idAction).getActions().get(idReponse).getName().contentEquals("BonneReponse")) {
			  joueur.getConnaissancesPossedees().add(reussite);
			  joueur.setPosition(lieu2);
			  break;   
		   }
		   
		   System.out.println("lieu courant : " + joueur.getPosition().getName());
		   System.out.println("Nombre de tentatives restantes : " + ((ObjetPresent)joueur.getObjetsPossedes().get(0)).getNbPoss());
	
	    }
		System.out.println(joueur.getPosition().getName());
    }
}

