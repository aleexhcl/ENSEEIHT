package pack;

import java.util.Collection;

import javax.persistence.*;

//import com.sun.xml.internal.bind.v2.schemagen.xmlschema.List;

@Entity

public class Profil {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	int id;
	String pseudo;
	String motdepasse;
	@OneToMany
	Collection<Profil> matchs;
	

	@OneToOne(mappedBy="profil5", fetch=FetchType.EAGER,cascade = CascadeType.ALL)
	Identite identite;
	
	@OneToOne(mappedBy="profil", fetch=FetchType.EAGER,cascade = CascadeType.ALL)
	Coordonnees coordonnees;
	
	@OneToOne(mappedBy="profil3", fetch=FetchType.EAGER,cascade = CascadeType.ALL)
	Physique caractPhysique;
	
	@OneToOne(mappedBy="profil2", fetch=FetchType.EAGER,cascade = CascadeType.ALL)
	Morale caractMorale;
	
	@OneToOne(mappedBy="profil4", fetch=FetchType.EAGER,cascade = CascadeType.ALL)
	Preference pref;
	
	
   
	
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}
	
	public Collection<Profil> getMatchs(){
		return matchs;
	}
	public void setMatchs(Collection<Profil> m) {
		this.matchs = m;
	}
	public Identite getIdentite() {
		return identite;
	}
	public void setIdentite(Identite identite) {
		this.identite = identite;
	}
	public String getPseudo() {
		return pseudo;
	}
	public void setPseudo(String pseudo) {
		this.pseudo = pseudo;
	}

	public String getMotdepasse() {
		return motdepasse;
	}
	public void setMotdepasse(String motdepasse) {
		this.motdepasse = motdepasse;
	}
	public Coordonnees getCoordonnees() {
		return coordonnees;
	}
	public void setCoordonnees(Coordonnees coordonnees) {
		this.coordonnees = coordonnees;
	}
	public Physique getCaractPhysique() {
		return caractPhysique;
	}
	public void setCaractPhysique(Physique caractPhysique) {
		this.caractPhysique = caractPhysique;
	}
	public Morale getCaractMorale() {
		return caractMorale;
	}
	public void setCaractMorale(Morale caractMorale) {
		this.caractMorale = caractMorale;
	}
	public Preference getPref() {
		return pref;
	}
	public void setPref(Preference pref) {
		this.pref = pref;
	}

}
