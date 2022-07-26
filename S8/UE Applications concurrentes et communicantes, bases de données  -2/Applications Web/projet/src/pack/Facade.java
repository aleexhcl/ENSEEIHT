package pack; 

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedList;


import javax.ejb.Singleton;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.TypedQuery;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

@Singleton
@Path("/")
public class Facade {
	
    
    @PersistenceContext
	EntityManager em ; 
    
    @POST
    @Path("/creationId")
    @Consumes({ "application/json" })
    public void ajoutId(Identite i) {
	/*Identite id = new Identite();
	id.setNom(nom);
	id.setAge(age);
	id.setLangues(langues);
	id.setPrenom(prenom);
	id.setSurnom(surnom);
	id.setNationnalite(nationnalite);
	id.setSexe(sexe);*/
	em.persist(i);
	}
    
    @POST
    @Path("/creationCoord")
    @Consumes({ "application/json" })
	public void ajoutCoord(Coordonnees coord) {
	/*Coordonnees coord = new Coordonnees();
	coord.setAdresse(adresse);
	coord.setFacebook(facebook);
	coord.setInsta(insta);
	coord.setNumero(numero);*/
	em.persist(coord);
	
	}
    @POST
    @Path("/creationMorale")
    @Consumes({ "application/json" })
	public void ajoutMorale(Morale m) {
	/*Morale morale = new Morale();
	morale.setTemperament(temperament);
	morale.setHabitude(habitude);
	morale.setValeurs(valeurs);
	morale.setTalents(talents);
	morale.setAnimaux(animaux);*/
	em.persist(m);
	}
    @POST
    @Path("/creationPhysique")
    @Consumes({ "application/json" })
	public void ajoutPhysique(Physique p) {
	/*Physique physique = new Physique();
	physique.setCoul_cheveux(coul_cheveux);
	physique.setLongueur_cheveux(longueur_cheveux);
	physique.setVetement(vetement);
	physique.setVoix(voix);
	physique.setYeux(yeux);
	physique.setTaille(taille);
	physique.setForme(forme);*/
	em.persist(p);
	}
    
    @POST
    @Path("/creationPref")
    @Consumes({ "application/json" })
	public void ajoutPref(Preference p) {
	/*Preference preference = new Preference();
	preference.setCaractMorales(morale);
	preference.setCaractPhysiques(physique);*/
	em.persist(p);
	}
	
    @POST
    @Path("/creationProfil")
    @Consumes({ "application/json" })
	public void creationProfil(Profil p) {	
    System.out.println("coucou");	
	em.persist(p);
	}
    @POST
    @Path("/ajoutProfil")
    @Consumes({ "application/json" })
	public void ajoutProfil(Profil p) {
    	
    System.out.println(p.getId());
    Profil profil = findProfil(p.getId());
	
    /*System.out.println(p.getMotdepasse());
	profil.setMotdepasse(p.getMotdepasse());
	profil.setPseudo(p.getPseudo());
	profil.setCaractMorale(p.getCaractMorale());
	profil.setCaractPhysique(p.getCaractPhysique());
	profil.setCoordonnees(p.getCoordonnees());
	profil.setIdentite(p.getIdentite());
	profil.setPref(p.getPref());*/
	
	
	em.merge(p);
	}
		
	
    @POST
    @Path("")
    @Consumes({ "application/json" })
	public Collection<Profil> listeProfils() {
		TypedQuery<Profil> req = em.createQuery("from Profil", Profil.class);
		return req.getResultList();
	}
	
    @POST
    @Path("")
    @Consumes({ "application/json" })
	public Collection<Coordonnees> listeCoordonnees() {
		TypedQuery<Coordonnees> req = em.createQuery("select c from Coordonnees c", Coordonnees.class);
		return req.getResultList();
	}
	
    @POST
    @Path("")
    @Consumes({ "application/json" })
	public Collection<Physique> listeCaracPhysiques() {
		TypedQuery<Physique> req = em.createQuery("select p from Physique p", Physique.class);
		return req.getResultList();
	}
	
    @POST
    @Path("")
    @Consumes({ "application/json" })
	public Collection<Morale> listeCaracMorales() {
		TypedQuery<Morale> req = em.createQuery("select m from Morale m", Morale.class);
		return req.getResultList();
	}
	
    @GET
    @Path("/checkConnexion")
    @Consumes({ "application/json" })
    public Profil checkConnexion(Profil p) {
    	String pseudo = p.getPseudo();
    	String motdepasse = p.getMotdepasse();
    	Profil profil = em.createQuery("select p from Profil p where pseudo:=pseudo and motdepasse:=motdepasse", 
    			Profil.class).setParameter("pseudo", pseudo).setParameter("motdepasse", motdepasse).getSingleResult();
    	return profil; 
    }
    
    @GET
    @Path("/checkPseudo")
    @Produces({ "application/json" })
    public boolean checkPseudo(Profil p){
    	String pseudo = p.getPseudo();
    	Profil profil = em.createQuery("select p from Profil p where pseudo:=pseudo", 
    			Profil.class).setParameter("pseudo", pseudo).getSingleResult();
    	return (profil==null); // profil non trouvé ?  
    }
    
    public float noteMatchingMorale(Morale morale1,Morale morale2) {
    	float note =0;
    	if (morale1.getTemperament()== morale2.getTemperament()) {
    		note=+1;
    	}
    	if (morale1.getHabitude()==morale2.getHabitude()) {
    		note +=1;
    	}
    	
    	if (morale1.getValeurs()== morale2.getValeurs()) {
    		note=+1;
    	}
    	if (morale1.getTalents()==morale2.getTalents()) {
    		note +=0.6;
    	}
    	
    	if (morale1.getAnimaux()==morale2.getAnimaux()) {
    		note +=0.05;
    	}
    	
    	
    	
    	
    	
    	return note;    	
    }
    
    public float noteMatchingPhysique(Physique physique1,Physique physique2) {
    	float note = 0;
    	if (physique1.getCoul_cheveux()==physique2.getCoul_cheveux()) {
    		note += 0.5;
    	}
    	if (physique1.getForme()==physique2.getForme()){
    		note += 1;
    	}
    	if (physique1.getLongueur_cheveux()==physique2.getLongueur_cheveux()) {
    		note +=0.5;
    	}
    	if (physique1.getVetement()==physique2.getVetement()) {
    		note +=0.8  ;	}
    	if (physique1.getVoix()==physique2.getVoix()) {
    		note += 0.3;
    	}
    	if (physique1.getYeux()==physique2.getYeux()){
    		note +=0.5;
 
    	}
    	float diff = Math.abs(physique1.getTaille()-physique2.getTaille());
    	if (diff<5) {
    		note +=0.8;
    	} else if (diff < 10) {
    		note +=0.4;
    	}
    	return note;
    }
    @GET
    @Path("/classementMatchMorale")
    @Produces({ "application/json" })
    public LinkedList<Profil> classementMatchMorale(Profil p){
    	LinkedList<Profil> list = new LinkedList<Profil>();
    	float aux = 1000;
    	for (Profil personne : listeProfils()) {
    		float note = noteMatchingMorale(personne.getCaractMorale(),p.getPref().getCaractMorales());
    		if (note<aux) {
    			list.add(personne);
    		}else {
    			list.add(0,personne);
    		}
    		aux = note;
    	}
    	return list;
    }
    @GET
    @Path("/classementMatchPhysique")
    @Produces({ "application/json" })
	 public LinkedList<Profil> classementMatchPhysique(Profil p){
    	LinkedList<Profil> list = new LinkedList<Profil>();
    	float aux = 1000;
    	for (Profil personne : listeProfils()){
    		float note = noteMatchingPhysique(personne.getCaractPhysique(),p.getPref().getCaractPhysiques());
    		if (note<aux) {
    			list.add(personne);
    		}else {
    			list.add(0,personne);
    		}
    		aux = note;
    	}
		return list;
    }
     
    @POST
    @Path("/ajoutMatch")
    @Consumes({ "application/json" })
	 public void ajoutMatch(Profil p) {
		 // ajouter à la liste des matchs 
    	 em.merge(p);
	}
    
    @GET
    @Path("/getMatch")
    @Consumes({ "application/json" })
	 public Collection<Profil> getMatch(int pseudoP) {
		 // recupere la liste des matchs 
    	 //Profil p = findProfil(pseudoPers);
    	 
    	 return em.createQuery("SELECT p from PROFIL_PROFIL p where p.PROFIL_ID = :pseudoP", Profil.class).setParameter("id",pseudoP).getResultList();	
	}
    
	 @POST
	 @Path("")
	 @Consumes({ "application/json" })
	 public Profil findProfil(int id) {
		 return em.find(Profil.class, id); 
	 }
	 
	 @POST
	 @Path("")
	 @Consumes({ "application/json" })
	 public Physique findPhysique(int id) {
		 return em.find(Physique.class, id); 
	 }
	 @POST
	 @Path("")
	 @Consumes({ "application/json" })
	 public Morale findMorale(int id) {
		 return em.find(Morale.class, id); 
	 }
	 @POST
	 @Path("")
	 @Consumes({ "application/json" })
	 public Preference findPreference(int id) {
		 return em.find(Preference.class, id); 
	 }
	 
	 @GET
	 @Path("/toVal")
	 @Consumes({ "application/json" })
	 public Sexe toEnumSexe(String sexe) {
		 return Sexe.valueOf(sexe);
	 }
	 
	 
}
