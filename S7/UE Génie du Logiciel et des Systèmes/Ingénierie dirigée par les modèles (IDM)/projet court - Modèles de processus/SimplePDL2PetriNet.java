
package simplepdl.manip;
import org.eclipse.emf.ecore.EObject;
import simplepdl.Process;
import simplepdl.Ressource;
import simplepdl.RessourcesNecessaires;
import simplepdl.WorkDefinition;
import simplepdl.WorkSequence;
import simplepdl.WorkSequenceType;
/*import simplepdl.SimplepdlFactory;*/
import simplepdl.SimplepdlPackage;
import petrinet.PetriElement;
import petrinet.ReseauPetri;
import petrinet.Place;
import petrinet.ReadArc;
import petrinet.Transition;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl;
import petrinet.Arc;
import petrinet.util.*;
import petrinet.Boite;
import petrinet.PetrinetFactory;
import petrinet.PetrinetPackage;
import org.eclipse.emf.ecore.EPackage;
public class SimplePDL2PetriNet {
	public static Map<String,Place> listeActivity;
	public static Map<String, Place> listeRessources;
	
	public static Process ouvrirSimplePld() {

		// Chargement du package SimplePDL afin de l'enregistrer dans le registre d'Eclipse.
		SimplepdlPackage packageInstancepdl = SimplepdlPackage.eINSTANCE;
		// Enregistrer l'extension ".xmi" comme devant Ãªtre ouverte Ã 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE;
		
		Map<String, Object> m = reg.getExtensionToFactoryMap();
		m.put("xmi", new XMIResourceFactoryImpl());
		// CrÃ©er un objet resourceSetImpl qui contiendra une ressource EMF (notre modÃ¨le)
		ResourceSet resSet = new ResourceSetImpl();
		
		// Charger la ressource (notre modÃ¨le)
		URI modelURI = URI.createURI("models/pdlRessource.xmi");
		Resource resourcePDL = resSet.getResource(modelURI,true);
		System.out.println(resourcePDL);
		// RÃ©cupÃ©rer le premier Ã©lÃ©ment du modÃ¨le (Ã©lÃ©ment racine)
		Process process = (Process) resourcePDL.getContents().get(0);
		return process;
	}

	public static Resource CreerPetri() {
		//Creation du réseau de petri associer
	    // Chargement du package petrinet afin de l'enregistrer dans le registre d'Eclipse.
		PetrinetPackage packageInstancepetri = PetrinetPackage.eINSTANCE;
	    
		// Enregistrer l'extension ".xmi" comme devant Ãªtre ouverte Ã 
		// l'aide d'un objet "XMIResourceFactoryImpl"
		Resource.Factory.Registry regpetri = Resource.Factory.Registry.INSTANCE;
		
		// CrÃ©er un objet resourceSetpetri qui contiendra une ressource EMF (notre modÃ¨le)
		ResourceSet resSetPetri = new ResourceSetImpl();
		Map<String, Object> mpetri = regpetri.getExtensionToFactoryMap();
		mpetri.put("xmi", new XMIResourceFactoryImpl());

		// CrÃ©er un objet resourceSetImpl qui contiendra une ressource EMF (notre modÃ¨le)
		ResourceSet resSetpetri = new ResourceSetImpl();
		System.out.print(resSetpetri==null);

		// Charger la ressource (notre modÃ¨le)
		URI modelURIpetri = URI.createURI("models/netReseauRessource.xmi");
		Resource resourcepetri = resSetPetri.createResource(modelURIpetri);
		return resourcepetri;
	}

	public static void main(String[] args) {
		
		Process process=ouvrirSimplePld();
		Resource resourcepetri=CreerPetri();
		
		// La fabrique pour fabriquer les Ã©lÃ©ments de SimplePDL
	    PetrinetFactory myFactory = PetrinetFactory.eINSTANCE;
	    
		// CrÃ©er un Ã©lÃ©ment Process
		ReseauPetri petri = myFactory.createReseauPetri();
		petri.setName(process.getName());
		
		// Ajouter le Process dans le modÃ¨le
		resourcepetri.getContents().add( petri);
	    
	    listeRessources=new HashMap<String,Place>();
	    
	    for (Object o : process.getProcessElements()) {

	    	if ( o instanceof Ressource ) {
	    		Place ressource = myFactory.createPlace();
	    		ressource.setNbJetons(((Ressource) o).getQuantite());
	    		ressource.setName(((Ressource) o).getName());
	    		petri.getPetriElements().add(ressource);
	    		listeRessources.put(ressource.getName(), ressource);
	    	}
	    }
	    for (Object o : process.getProcessElements()) {
			if (o instanceof WorkDefinition) {
				
				WorkDefinition wd = (WorkDefinition) o;
				String Nom = wd.getName();
				Place ready = myFactory.createPlace();
				ready.setName(Nom+"_ready");
				ready.setNbJetons(1);
				petri.getPetriElements().add(ready);
				Transition start = myFactory.createTransition();
				start.setName(Nom+"_start");
				petri.getPetriElements().add(start);
				Place started = myFactory.createPlace();
				started.setName(Nom+"_started");
				petri.getPetriElements().add(started);
				Transition finish = myFactory.createTransition();
				finish.setName(Nom+"_finish");
				petri.getPetriElements().add(finish);
				Place finished = myFactory.createPlace();
				finished.setName(Nom+"_finished");
				petri.getPetriElements().add(finished);

				Arc ready2start = myFactory.createArc();
				ready2start.setNbJetons(1);
				ready2start.setPredecessor(ready);
				ready2start.setSuccessor(start);
				petri.getPetriElements().add(ready2start);
				Arc start2started = myFactory.createArc();
				start2started.setNbJetons(1);
				start2started.setPredecessor(start);
				start2started.setSuccessor(started);
				
				petri.getPetriElements().add(start2started);
				Arc started2finish = myFactory.createArc();
				started2finish.setNbJetons(1);
				started2finish.setPredecessor(started);
				started2finish.setSuccessor(finish);
				petri.getPetriElements().add(started2finish);
				Arc finish2finished = myFactory.createArc();
				finish2finished.setNbJetons(1);
				finish2finished.setPredecessor(finish);
				finish2finished.setSuccessor(finished);
				petri.getPetriElements().add(finish2finished);
				
					
					
						// chercher si la ressource est utilisée par la wd 
						for (RessourcesNecessaires ress_necess : wd.getLinkToRessources()) {
									
									Place ressource= listeRessources.getOrDefault(ress_necess.getRessourceutilise().getName(), null);
									
									if (ressource==null) {
										System.out.println("erreur");
									} else {
										
										
										Arc arcRessource = myFactory.createArc();
										arcRessource.setNbJetons(ress_necess.getNb());
										arcRessource.setPredecessor((Place) ressource);
										arcRessource.setSuccessor(start);
										petri.getPetriElements().add(arcRessource);
										Arc retourRessource= myFactory.createArc();
										retourRessource.setNbJetons(ress_necess.getNb());
										retourRessource.setPredecessor(finish);
										retourRessource.setSuccessor(ressource);
										petri.getPetriElements().add(retourRessource);
									}
							}
						}
					}
				 
				
		
	    
	    for (Object o: process.getProcessElements()) {
	    	if (o instanceof WorkSequence) {
	    		WorkSequence ws= (WorkSequence) o;
	    		Arc arc_ws = myFactory.createArc();
	    		ReadArc rd_arc = myFactory.createReadArc();
	    		Place memoire= myFactory.createPlace();
	    		
	    		String nom_pred = ws.getPredecessor().getName();
	    		String nom_succ = ws.getSuccessor().getName();
	    		memoire.setName(nom_pred+ws.getLinkType()+nom_succ);
	    		String nom_depart_petri=nom_pred;
	    		String nom_fin_petri=nom_succ;
	    		
	    		
	    		switch (ws.getLinkType()) {
	    			case START_TO_START: 
	    				nom_depart_petri+="_start";
	    				nom_fin_petri+="_start";
	    				break;
	    			case START_TO_FINISH:
	    				nom_depart_petri+="_start";
	    				nom_fin_petri+="_finish";
	    				break;
	    			case FINISH_TO_START:
	    				nom_depart_petri+="_finish";
	    				nom_fin_petri+="_start";
	    				break;
	    			case FINISH_TO_FINISH:
	    				nom_depart_petri+="_finish";
	    				nom_fin_petri+="_finish";
	    				break;	
	    			default:
	    				nom_depart_petri="erreur";
	    				nom_fin_petri="erreur";
	    				break;
	    		}
	    		
	    		
	    		
	    		for (PetriElement b : petri.getPetriElements()) {
	    		
    				if (b instanceof Transition) {
    					Transition tr= (Transition) b;
    					if ((tr).getName().equals(nom_depart_petri)) {
    						arc_ws.setPredecessor(tr);
    					}
    					if (tr.getName().equals(nom_fin_petri)) {
    						rd_arc.setSuccessor(tr);
    					}
    				}
    			}
	    		rd_arc.setPredecessor(memoire);
    			arc_ws.setSuccessor(memoire);
    			arc_ws.setNbJetons(1);
    			rd_arc.setNbJetons(1);
	    		petri.getPetriElements().add(arc_ws);
	    		petri.getPetriElements().add(rd_arc);
	    		petri.getPetriElements().add(memoire);	
	    	}
	    }
		
	    try {
	    resourcepetri.save(Collections.EMPTY_MAP);
	    } catch(IOException e) {
	    }
	}
}

