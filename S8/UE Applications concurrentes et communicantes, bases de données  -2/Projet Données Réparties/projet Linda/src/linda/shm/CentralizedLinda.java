package linda.shm;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import java.util.*;
import java.util.Map.Entry;

import linda.Callback;
import linda.Linda;
import linda.Tuple;

/** Shared memory implementation of Linda. */
public class CentralizedLinda implements Linda {
    
    final Lock moniteur;
    private ConcurrentHashMap<Tuple, Integer> mes_tuples;
    private Map<Tuple, ArrayList<Callback>> abonnements_take;
    private Map<Tuple, ArrayList<Callback>> abonnements_read;
    private Map<Condition, Tuple> templEnAttente;
    private Tuple nvResultat;

    public CentralizedLinda() {
        this.mes_tuples = new ConcurrentHashMap<Tuple, Integer>();
        this.abonnements_take = new HashMap<Tuple, ArrayList<Callback>>();
        this.abonnements_read = new HashMap<Tuple, ArrayList<Callback>>();
        this.moniteur = new ReentrantLock();
        this.templEnAttente = new HashMap<Condition, Tuple>();
        this.nvResultat = new Tuple();
    }

    public void write(Tuple t){
        // ecriture semi-parallele
        Tuple tt = t.deepclone();
        if (mes_tuples.containsKey(tt)) {
        	Integer nb = mes_tuples.get(tt);
        	mes_tuples.replace(tt, nb+1);
        } else {
        	mes_tuples.put(tt, 1);
        }

		if (templEnAttente != null) {
			moniteur.lock(); // bloque pour les traitements en attente
			Set<Entry<Condition, Tuple>> set = templEnAttente.entrySet();
			Iterator<Entry<Condition, Tuple>> iterator = set.iterator();

			while (iterator.hasNext()) {
				Entry<Condition, Tuple> entry = iterator.next();
				Tuple template = entry.getValue();
				Condition cond = entry.getKey();
				if (tt.matches(template)) {
					nvResultat = tt.deepclone();
					cond.signal();
					iterator.remove();
				}
			}

			moniteur.unlock();

		}

        appelAbonnement(abonnements_read, eventMode.READ, tt);
        appelAbonnement(abonnements_take, eventMode.TAKE, tt);

		//moniteur.unlock();
    }

    // fonction pour gerer les abonnements

	private void appelAbonnement(Map<Tuple, ArrayList<Callback>> abonnements, eventMode mode, Tuple tuple) {
    	if (abonnements != null) {
	    	boolean take = false;
	    	Tuple tupleASupp = new Tuple();
	    	ArrayList<Callback> callbackASupp = new ArrayList<Callback>();

	    	// test pour le take si tuple direct obtenu
	    	if (mode == eventMode.TAKE && mes_tuples.containsKey(tuple) && mes_tuples.get(tuple) > 0
	    			&& abonnements.get(tuple) != null && !(abonnements.get(tuple).isEmpty())) {
	    		take = true;
	    		Callback cb = abonnements.get(tuple).get(0);
	    		cb.call(tuple);
	    		abonnements.remove(tuple,cb);
	    	}

	    	if (!take) {
				Set<Entry<Tuple, ArrayList<Callback>>> set = abonnements.entrySet();

				for (Map.Entry<Tuple, ArrayList<Callback>> entry : set) {
		            Tuple template = entry.getKey();
		            ArrayList<Callback> listcallback = new ArrayList<Callback>(entry.getValue());

		            if (tuple.matches(template)) {
		            	if (mode == eventMode.READ) {
		            		for (Callback callback : listcallback) {
		            			callback.call(tuple);  // call tous les abonnements possibles, le tuple est toujours dans la mémoire
								entry.getValue().remove(callback);//abonnements.remove(template, callback);

		            		}
		            	} else {
		            		if (! listcallback.isEmpty()) {
		            			take = true;
		            			Callback callback = listcallback.get(0); // prend le premier callback sur ce template, car le tuple
		            			callback.call(tuple);                    // est ensuite enlevé de la mémoire
		            			mes_tuples.replace(tuple, mes_tuples.get(tuple)-1);
		            			entry.getValue().remove(callback); //abonnements.remove(template, callback);
		            		}
		            	}
		            }
		            if (take) {
		            	break;
		            }
		        }
	    	}
    	}
    }

    public Tuple take(Tuple template){
        // take parallele si tuple present
		Tuple resultat = null;

		if (mes_tuples.containsKey(template) && mes_tuples.get(template) > 0) {
			resultat = template.deepclone();
        	mes_tuples.replace(template, mes_tuples.get(template)-1);
	        return resultat;
		} else {
			for (Tuple tuple : mes_tuples.keySet()) {
				if (tuple.matches(template) && mes_tuples.get(tuple) > 0) {
				resultat = tuple.deepclone();
				mes_tuples.replace(tuple, mes_tuples.get(tuple)-1); // enlève slmt une occurence
		        return resultat;
				}
			}
		}

		if (resultat == null) {
			moniteur.lock(); // bloque pour attente
			Condition condTake = moniteur.newCondition();
			templEnAttente.put(condTake, template);
			try {
				condTake.await();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			moniteur.unlock();
        }

		if (mes_tuples.containsKey(template)) {
			mes_tuples.replace(template, mes_tuples.get(template)-1); // enlève slmt la premiere occurence
		} else {
			mes_tuples.put(template, 0);
		}

        return this.nvResultat;
    }

    public Tuple read(Tuple template){ //exactement la mm chose mais on remove pas
        //lecture parallele non bloquante sauf si template ne matche aucun tuple deja present

        Tuple resultat = null;

        if (mes_tuples.containsKey(template) && mes_tuples.get(template) > 0) {
			resultat = template.deepclone();
	        return resultat;
		} else {
			for (Tuple tuple : mes_tuples.keySet()) {
				if (tuple.matches(template) && mes_tuples.get(tuple) > 0) {
				resultat = tuple.deepclone();
		        return resultat;
				}
			}
		}

		if (resultat == null) {
			moniteur.lock(); // bloque si tuple non present
			Condition condRead = moniteur.newCondition();
			templEnAttente.put(condRead, template);
			try {
				condRead.await();
			} catch (InterruptedException e) {
				e.printStackTrace();
			} finally {
				moniteur.unlock();
			}
		}

        return nvResultat;
    }

    public Tuple tryTake(Tuple template){ //version non bloquante du take
        Tuple resultat = null;

		if (mes_tuples.containsKey(template) && mes_tuples.get(template) > 0) {
			resultat = template.deepclone();
        	mes_tuples.replace(template, mes_tuples.get(template)-1);
		} else {
			for (Tuple tuple : mes_tuples.keySet()) {
				if (tuple.matches(template) && mes_tuples.get(tuple) > 0) {
				resultat = tuple.deepclone();
				mes_tuples.replace(tuple, mes_tuples.get(tuple)-1); // enlève slmt une occurence
				break;
				}
			}
		}

        return resultat; // retournera null
    }

    public Tuple tryRead(Tuple template){ //version non bloquante du read
        Tuple resultat = null;

        if (mes_tuples.containsKey(template) && mes_tuples.get(template) > 0) {
			resultat = template.deepclone();
		} else {
			for (Tuple tuple : mes_tuples.keySet()) {
				if (tuple.matches(template) && mes_tuples.get(tuple) > 0) {
				resultat = tuple.deepclone();
				break; // sortie 1ere correspondance
				}
			}
		}
        return resultat; // retournera null
    }

    public Collection<Tuple> takeAll(Tuple template){
        moniteur.lock();
        Collection<Tuple> resultat = new ArrayList<Tuple>();

        for (Tuple tuple : mes_tuples.keySet()) {
            if (tuple.matches(template) && mes_tuples.get(tuple) > 0) {
            	resultat.add(tuple);
                mes_tuples.replace(tuple, mes_tuples.get(tuple)-1);
            }
        }
        moniteur.unlock();
        return resultat; // retournera la collection
    }

    public Collection<Tuple> readAll(Tuple template){
        moniteur.lock();
        Collection<Tuple> resultat = new ArrayList<Tuple>();

        for (Tuple tuple : mes_tuples.keySet()) {
            if (tuple.matches(template) && mes_tuples.get(tuple) > 0) {
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
    	for (Tuple tuple : mes_tuples.keySet()) {
    		if (mes_tuples.get(tuple) != 0) {
    			res += tuple;
    		}
            
        }
    	return res;
    }

    public void debug(String prefix){}
}
