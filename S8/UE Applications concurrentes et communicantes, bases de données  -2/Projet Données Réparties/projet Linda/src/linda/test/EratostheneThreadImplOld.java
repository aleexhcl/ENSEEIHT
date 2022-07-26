package linda.test;	
import java.util.ArrayList;

import linda.Linda;
import linda.Tuple;
import linda.shm.CentralizedLinda;
import linda.shm.CentralizedLindaOld;

public class EratostheneThreadImplOld implements Eratosthene {
	
	protected Linda linda;
    protected int taille;
    protected int nbthread;
	
	
	    public EratostheneThreadImplOld(int size, int nbthread) {
	        //Initialisation
	        this.taille = size;
	        this.nbthread = nbthread;
	        linda = new CentralizedLindaOld();
	        for (int iInt = 2; iInt <= taille; iInt++) {
	            linda.write(new Tuple(iInt));
	        }
	    }
	   
	    @Override
	    public ArrayList<Integer> recherche_premiers() {
	        ArrayList<Integer> premiers = new ArrayList<Integer>();

	        Thread[] nosthreads = new Thread[nbthread];
	        int curseurthread = 0;

	        int pas = taille/nbthread;
	        int fin = pas;
	        for (int debut = 2; debut <= taille ; debut += pas ) {
	        	
	            fin = debut + pas;
	            if (debut >= taille - pas){
	                fin = taille;
	            }
	            
	            //Lancement des Threads paralleles
	           EratostheneThread ert =  new EratostheneThread(debut,fin,linda,this);
	           Thread t = new Thread(ert);
	           //ajout dans le tableau
	           t.start();
	           nosthreads[curseurthread] = t;
	           
	           curseurthread++;
	           
	        }
	        //Attente de la fin des threads
	        for(int i = 0; i < nosthreads.length; i++){
	                try {
						nosthreads[i].join();
					} catch (InterruptedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	        }
	        //On récupère les nombres premiers restants
	        ArrayList<Tuple> nostuples = (ArrayList<Tuple>) linda.readAll(Tuple.valueOf("[ ?Integer ]"));
	        for( Tuple tuple : nostuples) {
	            Integer nombre= (Integer) tuple.element();
	            premiers.add(nombre);
	        }

	        return premiers;
	    }

	    @Override
	    public void enleverMultiples(int n) {
	        for (int j = 2*n; j <= taille; j += n) {
	            linda.tryTake(new Tuple(j));
	        }
	    }

}

