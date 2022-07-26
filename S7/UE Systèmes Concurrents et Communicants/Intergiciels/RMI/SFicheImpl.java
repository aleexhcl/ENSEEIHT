
public class SFicheImpl implements SFiche {
	private static final long serialVersionUID = 1;
	String fnom;
	String fmail;
	
	public SFicheImpl(String n, String mail) {
		fnom = n;
		fmail = mail;
	}

	public String getNom () {
		return fnom;
	}
	
	public String getEmail () {
		return fmail;
	}

}
