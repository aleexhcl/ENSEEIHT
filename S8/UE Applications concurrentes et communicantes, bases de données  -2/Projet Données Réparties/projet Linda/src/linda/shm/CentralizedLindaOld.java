package linda.shm;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.*;
import java.util.Map.Entry;

import linda.Callback;
import linda.Linda;
import linda.Tuple;

/** Shared memory implementation of Linda. */
public class CentralizedLindaOld implements Linda {
    
    final Lock moniteur;
    final Lock mon2;
    private ArrayList<Tuple> mes_tuples;
    private Map<Tuple, ArrayList<Callback>> abonnements_take;
    private Map<Tuple, ArrayList<Callback>> abonnements_read;
    private Map<Condition, Tuple> templEnAttente;
    private Tuple nvResultat;

    public CentralizedLindaOld() {
        this.mes_tuples = new ArrayList<Tuple>();
        this.abonnements_take = new HashMap<Tuple, ArrayList<Callback>>();
        this.abonnements_read = new HashMap<Tuple, ArrayList<Callback>>();
        this.moniteur = new ReentrantLock();
        this.mon2 = new ReentrantLock();
        this.templEnAttente = new HashMap<Condition, Tuple>();
        this.nvResultat = new Tuple();
    }

    public void write(Tuple t){
        moniteur.lock();// pour pas lire tant qu'on a pas écrit
        Tuple tt = t.deepclone();
		mes_tuples.add(tt);
		
		if (templEnAttente != null) {
			Set<Entry<Condition, Tuple>> set = templEnAttente.entrySet();
		
			for (Map.Entry<Condition, Tuple> entry : set ) {
				Tuple template = entry.getValue();
				Condition cond = entry.getKey();
				if (tt.matches(template)) {
					nvResultat = tt.deepclone();
					cond.signal();
					templEnAttente.remove(cond, template);
				}
			}
		}

        appelAbonnement(abonnements_read, eventMode.READ, tt);
        appelAbonnement(abonnements_take, eventMode.TAKE, tt);
        
		moniteur.unlock();
    }
    
    // fonction pour gerer les abonnements 
    
	private void appelAbonnement(Map<Tuple, ArrayList<Callback>> abonnements, eventMode mode, Tuple tuple) {
		mon2.lock();
		
    	if (abonnements != null) {
    	
    	boolean take = false;
    	Tuple tupleASuppRead = new Tuple();
    	ArrayList<Callback> callbackASupp = new ArrayList<Callback>();
    	Tuple tupleASuppTake = new Tuple();
    	
    	Set<Entry<Tuple, ArrayList<Callback>>> set = abonnements.entrySet();
    	for (Map.Entry<Tuple, ArrayList<Callback>> entry : set) {
            Tuple template = entry.getKey();
            ArrayList<Callback> listcallback = new ArrayList<Callback>(entry.getValue());
            
            if (tuple.matches(template)) {
            	if (mode == eventMode.READ) {
            		for (Callback callback : listcallback) { 
            			callback.call(tuple);  // call tous les abonnements possibles, le tuple est toujours dans la mémoire
            			callbackASupp.add(callback);
            			tupleASuppRead = template.deepclone();
            		}
            		
            		//tupleASuppRead.add(template);    // On garde dans les abonnements ceux au read 
            	} else {
            		if (! listcallback.isEmpty()) {
            		take = true; 
            		Callback callback = listcallback.get(0); // prend le premier callback sur ce template, car le tuple
            		callback.call(tuple);                    // est ensuite enlevé de la mémoire
            		
            		callbackASupp.add(callback);
            		tupleASuppTake = template.deepclone();
            		}
            	}
            }
            if (take) {
            	break;
            }
        }
    	
    	if (take) {
    		for (Callback cb : callbackASupp) {
    			abonnements.remove(tupleASuppTake, cb);
    		}
			mes_tuples.remove(tuple);
		}
    	
        if (! tupleASuppRead.isEmpty()) {
        	for (Callback cb : callbackASupp) {
        		abonnements.remove(tupleASuppRead, cb);
        	}
    	}
    	}
    	mon2.unlock();
    }

    public Tuple take(Tuple template){
		moniteur.lock();

        //mode bloquant on ajoute un deuxieme moniteur 
        //soit mode bloquant = boucle infini tant qu'on a pas le tuple 
		Tuple resultat = null;
        
		for (Tuple tuple : mes_tuples) {
			if (tuple.matches(template)) {
			resultat = tuple.deepclone();
			mes_tuples.remove(tuple); // enlève slmt la premiere occurence 
			moniteur.unlock();
	        return resultat;
			}
		}
		if (resultat == null) {
			Condition condTake = moniteur.newCondition();
			templEnAttente.put(condTake, template);
			try {
				condTake.await();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
        }
		mes_tuples.remove(nvResultat); // enlève slmt la premiere occurence 
        moniteur.unlock();
        return this.nvResultat;
    }

    public Tuple read(Tuple template){ //exactement la mm chose mais on remove pas
		moniteur.lock();

        //mode bloquant on ajoute un deuxieme moniteur 
        //soit mode bloquant = boucle infini tant qu'on a pas le tuple 

        Tuple resultat = null;
       
		for (Tuple tuple : mes_tuples) {
			if (tuple.matches(template)) {
				resultat = tuple.deepclone();
				moniteur.unlock();
		        return resultat;
			}
		}
		
		if (resultat == null) {
			Condition condRead = moniteur.newCondition();
			templEnAttente.put(condRead, template);
			try {
				condRead.await();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
        
        moniteur.unlock();
        return nvResultat;
    }

    public Tuple tryTake(Tuple template){ //version non bloquante du take
        moniteur.lock();
       
        //mode non bloquant on ajoute un deuxieme moniteur 

       
        Tuple resultat = null;
        for (Tuple tuple : mes_tuples) {
            if (tuple.matches(template)) {
            	resultat = tuple.deepclone();
                mes_tuples.remove(tuple);
                break;
            }
        }
        moniteur.unlock();
        return resultat; // retournera null
    }

    public Tuple tryRead(Tuple template){ //version non bloquante du read
        moniteur.lock();
        
        //mode non bloquant on ajoute un deuxieme moniteur 

        Tuple resultat = null;
        for (Tuple tuple : mes_tuples) {
        	if (tuple.matches(template)) {
        		resultat = tuple.deepclone();
                break;
            }
        }
        moniteur.unlock();
        return resultat; // retournera null
    }

    public Collection<Tuple> takeAll(Tuple template){
        moniteur.lock();
        Collection<Tuple> resultat = new ArrayList<Tuple>();

        for (Tuple tuple : mes_tuples) {
            if (tuple.matches(template)) {
            	resultat.add(tuple);
                mes_tuples.remove(tuple);
            }
        }
        moniteur.unlock();
        return resultat; // retournera la collection
    }

    public Collection<Tuple> readAll(Tuple template){
        moniteur.lock();
        Collection<Tuple> resultat = new ArrayList<Tuple>();

        for (Tuple tuple : mes_tuples) {
            if (tuple.matches(template)) {
            	resultat.add(tuple);
            }
        }
        moniteur.unlock();
        return resultat; // retournera la collection
    }

    public void eventRegister(eventMode mode, eventTiming timing, Tuple template, Callback callback){
        Tuple t = null;
        if (mode == eventMode.READ && timing == eventTiming.IMMEDIATE){
            t = tryRead(template);
        } else if (mode == eventMode.TAKE && timing == eventTiming.IMMEDIATE) {
            t = tryTake(template);
        }

        if(t != null && timing == eventTiming.IMMEDIATE){
            callback.call(t);
        } else { //Si on a t = null ou timing = future
            if (mode == eventMode.READ ){
            	ArrayList<Callback> list = abonnements_read.get(template);
            	if (list == null) {
            		list = new ArrayList<Callback>(); 
            	}
            	list.add(callback);
                abonnements_read.put(template,list);
             } else {
            	ArrayList<Callback> list = abonnements_take.get(template);
            	if (list == null) {
            		list = new ArrayList<Callback>(); 
            	}
             	list.add(callback);
                abonnements_take.put(template,list);
             }  
        }
    }
    
    public String toString() {
    	String res = "";
    	for (Tuple tuple : mes_tuples) {
            res += tuple;
        }
    	return res;
    }

    public void debug(String prefix){}
}
