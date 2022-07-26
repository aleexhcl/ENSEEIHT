package linda.test;

import java.util.ArrayList;

public class CreateEratostheneThread {

    public static void main(String[] args) {
        try{
        	long debut = System.currentTimeMillis();
        	//int taille = Integer.parseInt(args[0]);
        	//int nbth = Integer.parseInt(args[1]);
        	int taille = 70000;
        	int nbth = 4; 
        EratostheneThreadImpl erat = new EratostheneThreadImpl(taille, nbth);
        ArrayList<Integer> premiers = erat.recherche_premiers();
        System.out.println(premiers);
        System.out.println("temps exécution thread : "+(System.currentTimeMillis()-debut));
        } catch (Exception e) {
        	e.printStackTrace();
            System.out.println("Saisir un nombre puis le nombre de thread que vous souhaitez utiliser");
        }
    }

}
