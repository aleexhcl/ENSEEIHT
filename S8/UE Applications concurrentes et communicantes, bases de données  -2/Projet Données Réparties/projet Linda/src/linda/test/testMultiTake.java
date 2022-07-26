package linda.test;

import linda.Linda;
import linda.Tuple;
import linda.multiserver.LindaMulti;

public class testMultiTake {
	public static void main(String[] a) {
		
        final LindaMulti linda = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti");
        final LindaMulti linda2 = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti");

           new Thread() {
            public void run() {
                Tuple motif = new Tuple(Integer.class);


                System.out.print(" Test de take sur vide ");
                Tuple t = linda2.take(motif);
                System.out.println(" Resultat:" + t);
                
            }
        }.start();
                
        new Thread() {
            public void run() {
            	Tuple motif = new Tuple(Integer.class);
            	try {
					Thread.sleep(2000);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
                 linda.write(new Tuple(6));
                 
            }
        }.start();

    }

}
