package linda.test;	

import linda.Linda;
import linda.Tuple;
import linda.shm.CentralizedLinda;

import java.util.ArrayList;

public class EratostheneImpl implements Eratosthene {

	    protected Linda linda;
	    protected int taille;

	    public EratostheneImpl(int size) {
	        //Initialisation
	    	
	    	this.taille = size;
	    	linda = new CentralizedLinda();
	    	for (int iInt = 2; iInt <= size; iInt++) {
	    		linda.write(new Tuple(iInt));
	    	}	
	    }

	    @Override
	    public ArrayList<Integer> recherche_premiers() {
	        ArrayList<Integer> premiers = new ArrayList<Integer>();
	        for (int i = 2; i <= taille; i++) {
	            Tuple tuplecourant = linda.tryRead(new Tuple(i));
	            if (tuplecourant != null){
	                enleverMultiples(i);
	                premiers.add(i);
	            }
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
