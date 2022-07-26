package linda.test;

import linda.*;
public class testCache {
    public static void main(String[] a) {

        //final Linda linda = new linda.shm.CentralizedLinda();
        final Linda linda = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti");
        final Linda linda2 = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti");


           new Thread() {
            public void run() {
                long debut = System.currentTimeMillis();
                Tuple motif = new Tuple(Integer.class);

                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

                Tuple t = linda2.tryRead(motif);
                System.out.println(" Resultat:" + t);
                linda2.write(new Tuple(5));
                
                
                try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                
                linda2.write(new Tuple("a")); 
                motif = new Tuple(String.class);

                t = linda2.tryRead(motif);
                System.out.println(" Resultat:" + t);
                long fin = System.currentTimeMillis();
                System.out.println(fin - debut);
            }
        }.start();
                
        new Thread() {
            public void run() {
                 long debut = System.currentTimeMillis();
                    Tuple motif = new Tuple(Integer.class);
                    
                    linda.write(new Tuple("b"));
                
    
                    long fin = System.currentTimeMillis();
                    System.out.println(fin - debut);

            }
        }.start();

    }
}