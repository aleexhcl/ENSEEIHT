/** Classe regroupant les tests unitaires de la classe Monnaie.  */
public class MonnaieTest {

	protected Monnaie m1;
	protected Monnaie m2;

	@Avant
	public void debut() {
		this.m1 = new Monnaie(5, "euro");
		this.m2 = new Monnaie(7, "fjh");
	}

		@UnTest (expected = DeviseInvalideException.class)
	public void Ajouter() throws DeviseInvalideException {
		m1.ajouter(m2);
		Assert.assertTrue(m1.getValeur() == 12);
	}

	@UnTest ( enabled = "false", expected = DeviseInvalideException.class)
	public void Retrancher() throws DeviseInvalideException {
		m1.retrancher(m2);
		Assert.assertTrue(m1.getValeur() == -2);
	}
	
	@UnTest ( expected = DeviseInvalideException.class)
	public void Retrancher2() throws DeviseInvalideException {
		m1.retrancher(m2);
		Assert.assertTrue(m1.getValeur() == -2);
	}

}
