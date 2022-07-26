
package linda.test;

import linda.*;

public class testCachePerformance {
    public static void main(String[] a) {

        //final Linda linda = new linda.shm.CentralizedLinda();
        final Linda linda = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti");
        //final Linda linda2 = new linda.server.LindaClient("//localhost:4005/Linda");


           new Thread() {
            public void run() {
                Tuple motif = new Tuple(Integer.class);


                for (int i = 1; i <= 10000; i++){
                    linda.write(new Tuple(i));
                }
                for (int i = 1; i <= 200; i++){
                    linda.write(new Tuple(i,i));
                }
                for (int i = 1; i <= 200; i++){
                    linda.write(new Tuple(i,i,i));
                }

                
                long debut = System.currentTimeMillis();
                
                linda.tryRead(new Tuple(9000));
                linda.tryRead(new Tuple(150,150));
                linda.tryRead(new Tuple(150,150,150));

                long fin = System.currentTimeMillis();
                System.out.println("Sans cache");
                System.out.println("Temps d'éxecution " + (fin - debut) + "ms");
                System.out.println("");
            }
        }.start();
                
        new Thread() {
            public void run() {
                
                 
                 try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                 linda.write(new Tuple(9000));
                 
                long debut = System.currentTimeMillis();
                linda.tryRead(new Tuple(9000));
                linda.tryRead(new Tuple(150,150));
                linda.tryRead(new Tuple(150,150,150));
                
                long fin = System.currentTimeMillis();
                System.out.println("Avec cache");
                System.out.println("Temps d'éxecution " + (fin - debut) + "ms");
            }
        }.start();

    }
}

