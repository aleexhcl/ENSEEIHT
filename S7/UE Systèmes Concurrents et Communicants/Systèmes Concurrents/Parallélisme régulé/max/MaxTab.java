//v0.1.2 15/11/21 (PM) (0.1.2 : modification (mineure) des parties à compléter)

import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.file.LinkOption;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.util.concurrent.ExecutionException;

import java.util.List;
import java.util.LinkedList;

import java.util.concurrent.Future;
import java.util.concurrent.Callable;
import java.util.concurrent.Executors;
import java.util.concurrent.ExecutorService;

import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinPool;

class MaxLocal  implements Callable<Integer> {
// pool fixe
    private int début;
    private int fin;
    private int[] tableau;

    MaxLocal(int[] t, int d, int f) {
        début = d;
        fin = f;
        tableau = t;
    }

    @Override
    public	Integer call() { // le résultat doit être un objet
        int ml = tableau[début];
// ********* A compléter
        for (int i = début+1; i < fin; i++) {
            if (tableau[i] > ml) {
                ml = tableau[i];
            }
        }
        return ml;
    }
}

class TraiterFragment extends RecursiveTask<Integer> {
// pool fork-join
    private int début;
    private int fin;
    private int[] tableau;
    static int seuil;

    private int max;

    TraiterFragment(int[] t, int d, int f) {
        début = d;
        fin = f;
        tableau = t;
        max = tableau[début];
    }

    protected Integer compute() {
        int taille;
        // si la tâche est trop grosse, on la décompose en 2
// ********* A compléter
        taille = fin - début;
        if ( taille > seuil) {
        	TraiterFragment tf1 = new TraiterFragment(tableau, début, (début+fin)/2-1);
        	TraiterFragment tf2 = new TraiterFragment(tableau, (début+fin)/2, fin);
        	
        	tf1.fork();
        	tf2.fork();
        	
        	max = Integer.max(tf1.join(), tf2.join());
        	
        	return max; 
        	
        } else {
        	for (int i = début; i < fin; i++) {
                if (tableau[i] > max) {
                    max = tableau[i];
                }
            }
        	return max;
        }
    }
}

public class MaxTab {
//--------- Mono
    static int maxMono(int[] t) {
        int max = 0;
        for (int i = 0; i < t.length; i++) {
            max = Math.max(t[i], max);
        }
        return max;
    }

//-------- Pool Fixe
    static int maxPoolFixe(ExecutorService xs, int[] t, int nbT)
    throws InterruptedException, ExecutionException {
        List<Future<Integer>> résultats=new LinkedList<Future<Integer>>();
        int max = t[0]; // on suppose que les entiers à trier sont positifs
        int grain = Math.max(1,t.length/nbT); 	/*taille d'une recherche locale 
        										 * = taille du tableau/nombre de tâches soumises
        										 * (ou 1 dans le cas (aberrant) où il y a plus
        										 * de tâches que d'éléments du tableau) */
// ********* A compléter (initialisation des variables)
        int d = 0;							//indice de départ d'une recherche locale
        int f = nbT;  						//indice de fin d'une recherche locale

        //soumettre les tâches
// ********* A compléter
        ExecutorService poule = Executors.newFixedThreadPool(grain);
        for (int i = 0 ; i < t.length-1 ; i += f) {
        	résultats.add( poule.submit(new MaxLocal(t, d + i, i + d + f-1)) );
        }
        poule.shutdown();

        //récupérer les résultats
// ********* A compléter
        int nb;
        for (Future<Integer> k : résultats) {
        	nb = k.get();
        	if (nb > max) {
        		max = nb;
        	}
        }
        return max;
    }

//-------- Pool ForkJoin
    static int maxForkJoin(ForkJoinPool f, int[] t) {
        TraiterFragment tout = new TraiterFragment(t,0, t.length-1);
        int max = f.invoke(tout); // ********* A corriger
        return max;
    }

//-------- main
    public static void main(String[] args)
    throws InterruptedException, ExecutionException, IOException, FileNotFoundException {

        
    	 
        int nbOuvriersPool=0; // nb ouvriers du pool fixe. Bonne valeur : nb de processeurs disponibles
        int nbEssais=-1;
        int nbTâches=-1;
        int tailleTronçon=-1; // nb d'éléments du tableau traités par chaque ouvrier (FJ) 
        String chemin="";
        int[] tableau;
        long départ, fin;
        int max;

        long[] tempsMono, tempsPool,tempsForkJoin;

        if (args.length == 5) { //analyse des paramètres
            chemin = args[0];
            try {
                nbEssais = Integer.parseInt (args[1]);
                nbTâches = Integer.parseInt (args[2]);
                tailleTronçon = Integer.parseInt (args[3]);
                nbOuvriersPool = Integer.parseInt (args[4]);
            }
            catch (NumberFormatException nfx) {
                throw new IllegalArgumentException("\nUsage : MaxTab <fichier> <nb essais>"
                                          	+" <nb tâches (pool)> <taille tronçon (FJ)>"
                                            + " <nb ouvriers du pool (pool)>\n"
                                            + " * <nb tâches (pool)> = nb de fragments à traiter \n"
                                            + " * <taille tronçon (FJ)> = taille du fragment \n");
                                    					}
        }
        if ((nbEssais<1) || (nbTâches<1) || (tailleTronçon<1) || (nbOuvriersPool<1)
                || !Files.isRegularFile(Paths.get(chemin), LinkOption.NOFOLLOW_LINKS))
                throw new IllegalArgumentException("\nUsage : MaxTab <fichier> <nb essais>"
                                          	+" <nb tâches (pool)> <taille tronçon (FJ)>"
                                            + " <nb ouvriers du pool (pool)>\n"
                                            + " * <nb tâches (pool)> = nb de fragments à traiter \n"
                                            + " * <taille tronçon (FJ)> = taille du fragment \n"); 
        //appel correct
        tempsMono = new long[nbEssais];
        tempsPool = new long[nbEssais];
        tempsForkJoin = new long[nbEssais];
        tableau=TableauxDisque.charger(chemin);
        System.out.println(Runtime.getRuntime().availableProcessors()+" processeurs disponibles pour la JVM");

        //créer un pool avec un nombre fixe d'ouvriers
        ExecutorService poule = Executors.newFixedThreadPool(nbOuvriersPool);

        //créer un pool ForkJoin
        ForkJoinPool fjp = new ForkJoinPool();
        TraiterFragment.seuil=tailleTronçon;

        for (int i = 0; i < nbEssais; i++) {
            départ = System.nanoTime();
            max = maxMono(tableau);
            fin = System.nanoTime();
            tempsMono[i] = (fin - départ);
            System.out.println("Essai ["+i+"] : maximum = " + max+", durée (mono) " +
                               tempsMono[i]/1_000+ "µs");
        }
        System.out.println("--------------------");

        for (int i = 0; i < nbEssais; i++) {
            départ = System.nanoTime();
            max = maxPoolFixe(poule, tableau, nbTâches);
            fin = System.nanoTime();
            tempsPool[i] = (fin - départ);
            System.out.println("Essai ["+i+"] : maximum = " + max+", durée (pool) " +
                               tempsPool[i]/1_000+ "µs");
        }
        poule.shutdown();
        System.out.println("--------------------");

        for (int i = 0; i < nbEssais; i++) {
            départ = System.nanoTime();
            max = maxForkJoin(fjp,tableau);
            fin = System.nanoTime();
            tempsForkJoin[i] = (fin - départ);
            System.out.println("Essai ["+i+"] : maximum = " + max+", durée (FJ) " +
                               tempsForkJoin[i]/1_000+ "µs");
        }
        System.out.println("--------------------");
    }
}
