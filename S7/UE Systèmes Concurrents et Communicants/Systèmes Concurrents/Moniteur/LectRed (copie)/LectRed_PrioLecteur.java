// Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: priorité aux lecteurs,
 * implantation: avec un moniteur. */
public class LectRed_PrioLecteur implements LectRed
{
    //protection des variables
    private Lock moniteur;

    private Condition condLect; // lecture possible
    private Condition condRed; // écriture possible 

    private boolean lecture;
    private int redacteurs;
    private int lecEnAttente;
    
    public LectRed_PrioLecteur()
    {
        this.moniteur = new ReentrantLock();
        this.condLect = moniteur.newCondition();
        this.condRed = moniteur.newCondition();
        this.lecture = false;
        this.lecEnAttente = 0;
        this.redacteurs = 0;
    }

    public void demanderLecture() throws InterruptedException
    {
        moniteur.lock();
	    lecEnAttente++;
	    while (lecture || redacteurs > 0) {
		    condLect.await();
	    }
	    lecture = true ;
        lecEnAttente--;	
	    condLect.signal();
        moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException
    {
        moniteur.lock();
	    lecture = false;
        if (lecEnAttente > 0 && redacteurs == 0) {
		    condLect.signal();
	    } else {
		    condRed.signal();
	    }
        moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException
    {
        moniteur.lock();
	    while (lecture || lecEnAttente > 0 || redacteurs > 0) {
		    condRed.await();
	    }
	    redacteurs++;
	    if (lecEnAttente == 0 && !lecture) {
		    condRed.signal();
	    }
        moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException
    {
        moniteur.lock();
        redacteurs--;
	    if (redacteurs == 0 && lecEnAttente > 0) {
		    condLect.signal();
	    }
        moniteur.unlock();
    }

    public String nomStrategie()
    {
        return "Stratégie: Priorité Lecteurs.";
    }
}








