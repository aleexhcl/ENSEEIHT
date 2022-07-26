// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem implements StrategiePhilo {

    /****************************************************************/
    private Semaphore[] blocagePhilo;
    public static EtatPhilosophe[] etats;
    private Semaphore mutex = new Semaphore(1);
    
    public PhiloSem (int nbPhilosophes) {
      blocagePhilo = new Semaphore[nbPhilosophes];
      for (int i = 0; i<nbPhilosophes; i++) {
        blocagePhilo[i] = new Semaphore(1);
      }
      etats = new EtatPhilosophe[nbPhilosophes];
        for (int i=0; i<nbPhilosophes; i++) {
            etats[i] = EtatPhilosophe.Pense;
        }
    }
    
    public boolean peutManger(int no) {
      return (etats[Main.PhiloDroite(no)]!=EtatPhilosophe.Mange) && (etats[Main.PhiloGauche(no)]!=EtatPhilosophe.Mange);
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
      mutex.acquire();
      if (peutManger(no)) {
        etats[no] = EtatPhilosophe.Mange;
        mutex.release();
      }
      else {
        etats[no] = EtatPhilosophe.Demande;
        mutex.release();
        blocagePhilo[no].acquire();
       }
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no) throws InterruptedException
    {
      mutex.acquire();
      etats[no] = EtatPhilosophe.Pense;
      if (etats[Main.PhiloGauche(no)]==EtatPhilosophe.Demande && peutManger(Main.PhiloGauche(no))) {
        etats[Main.PhiloGauche(no)] = EtatPhilosophe.Mange;
        blocagePhilo[Main.PhiloGauche(no)].release();
      }
      if (etats[Main.PhiloDroite(no)]==EtatPhilosophe.Demande && peutManger(Main.PhiloDroite(no))) {
        etats[Main.PhiloDroite(no)] = EtatPhilosophe.Mange;
        blocagePhilo[Main.PhiloDroite(no)].release();
      }
      mutex.release();
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie demande";
    }

}

