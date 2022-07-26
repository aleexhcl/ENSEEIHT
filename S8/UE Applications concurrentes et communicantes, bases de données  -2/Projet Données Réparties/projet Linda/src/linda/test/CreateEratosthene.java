package linda.test;

import java.util.ArrayList;

public class CreateEratosthene {
	
    public static void main(String[] args) {
    	try {
    		long debut = System.currentTimeMillis();
    		int n = Integer.parseInt(args[0]);
    		Eratosthene erat = new EratostheneImpl(n);
    		ArrayList<Integer> premiers = erat.recherche_premiers();
    		System.out.println(premiers);
    		System.out.println("temps exécution sans thread : "+(System.currentTimeMillis()-debut));
    	} catch (Exception e) {
    		System.out.println("entrez un nombre en argument");
    	}
    }
}
