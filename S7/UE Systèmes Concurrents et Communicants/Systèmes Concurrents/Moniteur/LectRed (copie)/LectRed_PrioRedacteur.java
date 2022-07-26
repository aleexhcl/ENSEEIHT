// Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux rédacteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioRedacteur implements LectRed
{
    //protection des variables
    private Lock moniteur;

    private Condition condLect; // lecture possible
    private Condition condRed; // écriture possible 

    private boolean redacteur;
    private int redEnAttente;
    private int lecteurs;
    
    public LectRed_PrioRedacteur()
    {
        this.moniteur = new ReentrantLock();
        this.condLect = moniteur.newCondition();
        this.condRed = moniteur.newCondition();
        this.redacteur = false;
        this.redEnAttente = 0;
        this.lecteurs = 0;
    }

    public void demanderLecture() throws InterruptedException
    {
        moniteur.lock();
        while (redEnAttente > 0 || redacteur) { //idem que !(!redacteur && redEnAttente == 0)
            condLect.await();
        }
        lecteurs++;
	    if (redEnAttente == 0 && !redacteur) {
        	condLect.signal();
	    }
        moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException
    {
        moniteur.lock();
        lecteurs--;
        if (lecteurs == 0 && redEnAttente > 0) {
            condRed.signal();
        }
        moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException
    {
        moniteur.lock();
        redEnAttente++;
        while (redacteur || lecteurs > 0 ) {
            condRed.await();
        }
        redacteur = true;
        redEnAttente--;
        condRed.signal();
        moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException
    {
        moniteur.lock();
        redacteur = false;
        if (redEnAttente > 0 && lecteurs == 0) {
            condRed.signal();
        } else {
		    condLect.signal();
	    }
        moniteur.unlock();
    }

    public String nomStrategie()
    {
        return "Stratégie: Priorité Rédacteurs.";
    }
}


// Signalement = if
// Attente d'accès = while 













