// Time-stamp: <08 Apr 2008 11:35 queinnec@enseeiht.fr>

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import Synchro.Assert;

/** Lecteurs/rédacteurs
 * stratégie d'ordonnancement: equitable (liste fifo);
 * implantation: avec un moniteur. */
public class LectRed_Equitable implements LectRed
{
    //protection des variables
    private Lock moniteur;

    private Condition sas;
    private Condition file;
    private boolean enAttente;
    private int redacteurs;
    private int lecteurs;  
    
    
    public LectRed_Equitable()
    {
        this.moniteur = new ReentrantLock();
        this.sas = moniteur.newCondition();
	    this.file = moniteur.newCondition();
	    this.enAttente = false;
        this.lecteurs = 0;
        this.redacteurs = 0;
    }

    public void demanderLecture() throws InterruptedException
    {
        moniteur.lock();
        while (enAttente || lecteurs > 0 || redacteurs > 0) { 
            file.await();
        }
        enAttente = true;
        while (lecteurs > 0 || redacteurs > 0) {
	        sas.await();
        }
	    lecteurs++;
	    enAttente = false;
	    file.signal();
        moniteur.unlock();
    }

    public void terminerLecture() throws InterruptedException
    {
        moniteur.lock();
        lecteurs--;
	    if (enAttente) {
		    sas.signal();
	    } else {
		    file.signal();
	    } 
        moniteur.unlock();
    }

    public void demanderEcriture() throws InterruptedException
    {
        moniteur.lock();
        while (enAttente || lecteurs > 0 || redacteurs > 0) { 
            file.await();
        }
        enAttente = true;
	    while (lecteurs > 0 || redacteurs > 0) {
	        sas.await();
        }
	    redacteurs++;
	    enAttente = false;
	    file.signal();
        moniteur.unlock();
    }

    public void terminerEcriture() throws InterruptedException
    {
        moniteur.lock();
        redacteurs--;
        if (enAttente) {
		    sas.signal();
	    } else {
            file.signal();
        }
        moniteur.unlock();
    }

    public String nomStrategie()
    {
        return "Stratégie: Equitable.";
    }
}




