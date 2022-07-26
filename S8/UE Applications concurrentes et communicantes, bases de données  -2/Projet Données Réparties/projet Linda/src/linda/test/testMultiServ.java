package linda.test;

import linda.*;
public class testMultiServ {
    public static void main(String[] a) {

        //final Linda linda = new linda.shm.CentralizedLinda();
        //final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
    	final Linda linda = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti"); 

                
        new Thread() {
            public void run() {
                 long debut = System.currentTimeMillis();
                    Tuple motif = new Tuple(Integer.class);
                    int nombre = 100;

                    /*if(!a[0].equals("")){
                        nombre = a[0];
                    }*/
                    
                    
                    for (int i = 1; i <= nombre; i++){
                        linda.tryRead(new Tuple(i));
                    }
                    for (int i = 1; i <= nombre; i++){
                        linda.tryRead(new Tuple(i,i-1));
                    }
                    for (int i = 1; i <= nombre; i++){
                        linda.tryRead(new Tuple(i,i-1, i+1));
                    }

                Tuple t = linda.tryRead(motif);
                System.out.println(" Resultat:" + t);
    
                long fin = System.currentTimeMillis();
                System.out.println(" Temps d'execution: " + (fin-debut) +" ms.");

            }
        }.start();

    }
}