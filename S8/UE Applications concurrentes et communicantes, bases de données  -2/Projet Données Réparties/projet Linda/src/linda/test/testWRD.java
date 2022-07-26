package linda.test;

import linda.*;
public class testWRD {
    public static void main(String[] a) {

        //final Linda linda = new linda.shm.CentralizedLinda();
        final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
    	
    	
        try{

            new Thread() {
                public void run() {
                long debut = System.currentTimeMillis();
                Tuple motif = new Tuple(Integer.class);
                int w = 50;
                int r = 50;
                int t = 50;

                /*if(!a[0].equals("")){
                    w = Integer.getInteger(a[0]);
                }
                if(!a[1].equals("")){
                    r = Integer.getInteger(a[1]);
                }if(!a[2].equals("")){
                    t = Integer.getInteger(a[2]);
                }*/

                for (int i = 1; i <= w; i++){
                    linda.write(new Tuple(i));
                }
                for (int i = 1; i <= r; i++){
                    linda.tryRead(motif);
                }
                for (int i = 1; i <= t; i++){
                    linda.tryTake(motif);
                }

                long fin = System.currentTimeMillis();
                System.out.println("Le programme s'éxecute en "+(fin-debut)+" ms");
                }
            }.start();

        }catch (Exception e) {
            System.out.println("Veuillez insérer en argument un nombre positif de write, read et take (par défaut 50 sinon)");
        }
    

}
}