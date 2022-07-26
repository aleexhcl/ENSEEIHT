package pack;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToOne;

@Entity
public class Preference {
	
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	int id;
	
	@OneToOne(cascade = CascadeType.ALL)
	Morale caractMorales;
	
	@OneToOne(cascade = CascadeType.ALL)
	Physique caractPhysiques;
	
	@OneToOne(cascade = CascadeType.ALL) 
	Profil profil4;
	
	/*public Preference(Morale caractMorales, Physique caractPhysiques) {
		super();
		this.caractMorales = caractMorales;
		this.caractPhysiques = caractPhysiques;
	}*/
	/*public Preference() {
		super();
		// TODO Auto-generated constructor stub
	}*/
	public Morale getCaractMorales() {
		return caractMorales;
	}
	public void setCaractMorales(Morale caractMorales) {
		this.caractMorales = caractMorales;
	}
	public Physique getCaractPhysiques() {
		return caractPhysiques;
	}
	public void setCaractPhysiques(Physique caractPhysiques) {
		this.caractPhysiques = caractPhysiques;
	}
}
