package linda.test;

import linda.Linda;
import linda.Tuple;

public class EratostheneThread implements Runnable {
	
	private int debut;
    private int fin;
    private Linda linda;
    private Eratosthene erat;

    public EratostheneThread(int debut, int fin, Linda li, Eratosthene er){
        this.debut = debut;
        this.fin = fin;
        this.linda = li;
        this.erat = er;
    }

    public void run () {
        for (int i = debut; i <= fin; i++) {
            Tuple courant = linda.tryRead(new Tuple(i));
            if (courant != null) {
                erat.enleverMultiples(i);
            }
        }
    }

}


