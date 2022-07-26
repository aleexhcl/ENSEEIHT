
package linda.test;

import linda.*;
public class testTryReadTryTake {
    public static void main(String[] a) {

        //final Linda linda = new linda.shm.CentralizedLinda();
        final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
        final Linda linda2 = new linda.server.LindaClient("//localhost:4000/Linda");


           new Thread() {
            public void run() {
                Tuple motif = new Tuple(Integer.class);


                System.out.print(" On obtient notre Tuple avec tryTake..");
                Tuple t = linda2.tryTake(motif);
                System.out.println(" Resultat:" + t);
                
                System.out.print(" On obtient 'null' avec tryRead..");
                t = linda2.tryTake(motif);
                System.out.println(" Resultat:" + t);

            }
        }.start();
                
        new Thread() {
            public void run() {
            	Tuple motif = new Tuple(Integer.class);
                 linda.write(new Tuple(4));
                 
                 try {
					Thread.sleep(10);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

                   linda.write(new Tuple(4));

                System.out.print(" On obtient 'null' avec tryRead..");
                Tuple t = linda2.tryRead(motif);
                System.out.println(" Resultat:" + t);
    
                  

            }
        }.start();
    }
}