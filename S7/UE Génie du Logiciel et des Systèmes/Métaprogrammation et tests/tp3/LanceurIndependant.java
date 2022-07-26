import java.lang.reflect.*;
import java.util.*;

/** L'objectif est de faire un lanceur simple sans utiliser toutes les clases
  * de notre architecture JUnit.   Il permet juste de valider la compréhension
  * de l'introspection en Java.
  */
public class LanceurIndependant {
	private int nbTestsLances;
	private int nbErreurs;
	private int nbEchecs;
	private int nbReussis;
	private List<Throwable> erreurs = new ArrayList<>();

	public LanceurIndependant(String... nomsClasses) {
	    System.out.println();

		// Lancer les tests pour chaque classe
		for (String nom : nomsClasses) {
			try {
				System.out.print(nom + " : ");
				this.testerUneClasse(nom);
				System.out.println();
			} catch (ClassNotFoundException e) {
				System.out.println(" Classe inconnue !");
			} catch (Exception e) {
				System.out.println(" Problème : " + e);
				e.printStackTrace();
			}
		}

		// Afficher les erreurs
		for (Throwable e : erreurs) {
			System.out.println();
			e.printStackTrace();
		}

		// Afficher un bilan
		System.out.println();
		System.out.printf("%d tests lancés dont %d échecs et %d erreurs.\n Nb reussi : %d\n",
				nbTestsLances, nbEchecs, nbErreurs, nbReussis);
	}


	public int getNbTests() {
		return this.nbTestsLances;
	}


	public int getNbErreurs() {
		return this.nbErreurs;
	}


	public int getNbEchecs() {
		return this.nbEchecs;
	}
	
	public int getNbReussis() {
		return this.nbReussis;
	}


	private void testerUneClasse(String nomClasse)
		throws ClassNotFoundException, InstantiationException,
						  IllegalAccessException
	{
		// Récupérer la classe

				Class notreClasse = Class.forName(nomClasse);

				Method preparer = null;
				Method nettoyer = null;

				// Récupérer les méthodes "preparer" et "nettoyer"

				// Instancier l'objet qui sera le récepteur des tests
				Object objet = notreClasse.newInstance();

				// Exécuter les méthods de test

				try  {
				for(Method m : notreClasse.getMethods()) {
					
					
						try {
							if (m.getAnnotation(Avant.class) != null ) {
								preparer = m;
							} else if (m.getAnnotation(Apres.class) != null ){
								nettoyer = m;
							}
								
							
							if (preparer != null) { preparer.invoke(objet); }
							int modifiers = m.getModifiers();
							
							
							//if ( Modifier.isStatic(modifiers) ) {
							UnTest annotation = m.getAnnotation(UnTest.class);
							if (annotation != null && annotation.enabled().contentEquals("true")) {
								nbTestsLances++;
								try{ m.invoke(objet);
								}catch (InvocationTargetException e) {
									if (e.getCause().getClass().equals(annotation.expected())) {
										nbReussis++;
									}
								}
								
							}
							//}
							
							if (nettoyer != null) { nettoyer.invoke(objet); } 
							
						} catch (InvocationTargetException e) { 
							
							if (e.getCause() instanceof Echec) {nbEchecs++;}
							
							else {nbErreurs++; erreurs.add(e);} 
						}

					}					
				
				} catch (Exception e) {
					System.out.println("Erreur methodes ");
				}
	}

	public static void main(String... args) {
		LanceurIndependant lanceur = new LanceurIndependant("MonnaieTest");
	}

}
