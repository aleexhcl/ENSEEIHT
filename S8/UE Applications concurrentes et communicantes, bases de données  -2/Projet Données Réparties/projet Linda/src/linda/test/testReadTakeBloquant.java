package linda.test;

import linda.*;
public class testReadTakeBloquant {
    public static void main(String[] a) {

        //final Linda linda = new linda.shm.CentralizedLinda();
        final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
        final Linda linda2 = new linda.server.LindaClient("//localhost:4000/Linda");


           new Thread() {
            public void run() {
                long debut = System.currentTimeMillis();
                Tuple motif = new Tuple(Integer.class);


                System.out.print(" On attend d'obtenir notre tuple... ");
                Tuple t = linda2.read(motif);
                System.out.println(" Resultat:" + t);
                
                Tuple motif2 = new Tuple(String.class);
                t = linda2.take(motif);
                System.out.print(" On attend d'obtenir notre tuple... ");
                System.out.println(" Resultat:" + t);

                long fin = System.currentTimeMillis();
                System.out.println(fin - debut);
            }
        }.start();
                
        new Thread() {
            public void run() {
                 long debut = System.currentTimeMillis();
                 
                 try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

                    linda.write(new Tuple(4));

                    try {
                        Thread.sleep(5000);
                    } catch (InterruptedException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                    linda.write(new Tuple("b"));
    
                    long fin = System.currentTimeMillis();
                    System.out.println(fin - debut);

            }
        }.start();

    }
}