package pack; 

import java.util.ArrayList;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;


@Entity
public class Physique {
	
	/*public enum Couleur { VERT, BLEU, NOIR, MARRON, ROUGE, GRIS, VIOLET }
	public enum CouleurChev { BRUN, BLOND, CHATAIN, BLANC, BLEU, ROSE, VIOLET, VERT, ROUGE, NOIR, AUTRES}
	public enum Taille { LONG, COURT, MILONG, RASE } //FRANGE ?
	public enum Style { VINTAGE, CHIC, CASUAL, SPORTSWEAR, BOHEME, ROMANTIQUE, FASHION, CLASSIQUE, ROCK, GOTHIQUE, LOLITA, SKATEUR, MINIMALISTE }
	public enum Voix { SOPRANO, ALTO, TENOR, BASSE, BARYTON }
	public enum Loisirs { SPORT, NETFLIX, RANDONNEE, CINÉMA, MUSIQUE, FETE, FAIRELAMOUR}*/
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	int id;
	int taille;
	String coul_cheveux;
	String longueur_cheveux;
	String yeux;
	String vetement; 
	String voix;
	String forme;
	
	@OneToOne(cascade = CascadeType.ALL) 
	 Profil profil3;

	
	/*public Physique(int taille, CouleurChev coul_cheveux, Taille longueur_cheveux, Couleur yeux, Style vetement,
			Voix voix, Forme forme) {
		super();
		this.taille = taille;
		this.coul_cheveux = coul_cheveux;
		this.longueur_cheveux = longueur_cheveux;
		this.yeux = yeux;
		this.vetement = vetement;
		this.voix = voix;
		this.forme = forme;
	}*/
	
	/*public Physique() {
		super();
	}*/

	public String getCoul_cheveux() {
		return coul_cheveux;
	}
	public void setCoul_cheveux(String coul_cheveux) {
		this.coul_cheveux = coul_cheveux;
	}
	public String getLongueur_cheveux() {
		return longueur_cheveux;
	}
	public void setForme(String forme) {
		this.forme = forme;
	}
	public String getForme() {
		return forme;
	}
	public void setLongueur_cheveux(String longueur_cheveux) {
		this.longueur_cheveux = longueur_cheveux;
	}
	public String getYeux() {
		return yeux;
	}
	public void setYeux(String yeux) {
		this.yeux = yeux;
	}
	public String getVetement() {
		return vetement;
	}
	public void setVetement(String vetement) {
		this.vetement = vetement;
	}
	public String getVoix() {
		return voix;
	}
	public void setVoix(String voix) {
		this.voix = voix;
	}
	public int getTaille() {
		return taille;
	}
	public void setTaille(int taille) {
		this.taille = taille;
	}
}
