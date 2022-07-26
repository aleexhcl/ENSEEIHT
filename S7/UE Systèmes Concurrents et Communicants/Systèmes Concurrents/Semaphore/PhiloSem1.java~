// Time-stamp: <08 déc 2009 08:30 queinnec@enseeiht.fr>

import java.util.concurrent.Semaphore;

public class PhiloSem1 implements StrategiePhilo {

    /****************************************************************/
    private Semaphore[] Fourchettes;
    
    public PhiloSem1 (int nbPhilosophes) {
    Fourchettes = new Semaphore[nbPhilosophes];
      for (int i = 0; i<nbPhilosophes; i++) {
        Fourchettes[i] = new Semaphore(1,true);
      }
    }

    /** Le philosophe no demande les fourchettes.
     *  Précondition : il n'en possède aucune.
     *  Postcondition : quand cette méthode retourne, il possède les deux fourchettes adjacentes à son assiette. */
    public void demanderFourchettes (int no) throws InterruptedException
    {
      Fourchettes[Main.FourchetteGauche(no)].acquire();
      
      Fourchettes[Main.FourchetteDroite(no)].acquire();
    }

    /** Le philosophe no rend les fourchettes.
     *  Précondition : il possède les deux fourchettes adjacentes à son assiette.
     *  Postcondition : il n'en possède aucune. Les fourchettes peuvent être libres ou réattribuées à un autre philosophe. */
    public void libererFourchettes (int no)
    {
      Fourchettes[Main.FourchetteGauche(no)].release();
      Fourchettes[Main.FourchetteDroite(no)].release();
    }

    /** Nom de cette stratégie (pour la fenêtre d'affichage). */
    public String nom() {
        return "Implantation Sémaphores, stratégie basique";
    }

}

