package pack; 

import java.util.ArrayList;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

@Entity
public class Morale {
	
	/*public enum Temperament { COLERIQUE, SANGUIN, FLEGMATIQUE, MELANCOLIQUE, DYNAMIQUE, CALME, SOLAIRE }
	public enum Habitude { CASANIER, FETARD, LEVETOT, ORGANISE, DESORDONNE, PONCTUEL }
	public enum Valeur { AMOUR, BIENVEILLANCE, BONTE, DIGNITE, DISCIPLINE, DOUCEUR, FIDELITE, HONNETETE, 
		LOYAUTE, NOBLESSE, PAIX, PARTAGE, PATIENCE, RESPECT, SOLIDARITE, TOLERANCE }
	public enum Talent { ARTISTE, SPORT, LANGUE, MUSIQUE, SCIENTIFIQUE, ARTISANAT }*/

	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	int id;
	
	String temperament;
	String habitude; 
	String valeurs;
	String talents; 
	String animaux; // animaux de compagnie > a changer en enum 

	@OneToOne(cascade = CascadeType.ALL) 
	 Profil profil2;
	
	
	
	/*public Morale() {
		super();
	}*/
	
	public String getTemperament() {
		return temperament;
	}
	public void setTemperament(String temperament) {
		this.temperament = temperament;
	}
	public String getHabitude() {
		return habitude;
	}
	public void setHabitude(String habitude) {
		this.habitude = habitude;
	}
	public String getValeurs() {
		return valeurs;
	}
	public void setValeurs(String valeurs) {
		this.valeurs = valeurs;
	}
	public String getTalents() {
		return talents;
	}
	public void setTalents(String talents) {
		this.talents = talents;
	}
	public String getAnimaux() {
		return animaux;
	}
	public void setAnimaux(String animaux) {
		this.animaux = animaux;
	}

}
