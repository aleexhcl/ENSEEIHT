package linda.test;

import linda.Callback;
import linda.Linda;
import linda.Tuple;
import linda.Linda.eventMode;
import linda.Linda.eventTiming;

public class testReadTake {
	
	public static void main(String[] a) {
        
        // final Linda linda = new linda.shm.CentralizedLinda();
        final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
                
        new Thread() {
            public void run() {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                
                Tuple t1 = new Tuple(4, 5);
                System.out.println("(2) write: " + t1);
                linda.write(t1);

                Tuple t11 = new Tuple(4, 9);
                System.out.println("(2) write: " + t11);
                linda.write(t11);

                Tuple t2 = new Tuple("hello", 15);
                System.out.println("(2) write: " + t2);
                linda.write(t2);

                Tuple t3 = new Tuple(4, "foo");
                System.out.println("(2) write: " + t3);
                linda.write(t3);
                
                Tuple tsi = new Tuple(String.class, Integer.class);
                Tuple tii = new Tuple(Integer.class, Integer.class);
                
                System.out.println();
                
                System.out.println("(3) linda avant take : " + linda.toString());
                System.out.println("take (string, integer)");
                Tuple t4 = linda.take(tsi);
                System.out.println("(3) tuple en sortie du take: " + t4);
                System.out.println("(3) linda apres take : " + linda.toString());
                
                System.out.println("(2) write: " + t2);
                linda.write(t2);
                
                System.out.println();
                
                System.out.println("(3) linda avant read : " + linda.toString());
                System.out.println("read (integer, integer)");
                t4 = linda.read(tii);
                System.out.println("(3) tuple en sortie du read: " + t4);
                System.out.println("(3) linda apres read : " + linda.toString());
                
                System.out.println();
                
                System.out.println("(3) linda avant tryTake : " + linda.toString());
                System.out.println("tryTake (integer, integer)");
                t4 = linda.tryTake(tii);
                System.out.println("(3) tuple en sortie du tryTake: " + t4);
                System.out.println("(3) linda apres tryTake : " + linda.toString());
                

                System.out.println("(2) write: " + t1);
                linda.write(t1);
                
                System.out.println();
                
                System.out.println("(3) linda avant tryTake : " + linda.toString());
                Tuple t5 = new Tuple(5,9);
                System.out.println("tryTake "+t5);
                t4 = linda.tryTake(t5);
                System.out.println("(3) tuple en sortie du tryTake: " + t4);
                System.out.println("(3) linda apres tryTake : " + linda.toString());
                
                System.out.println();
                
                System.out.println("(3) linda avant tryRead : " + linda.toString());
                System.out.println("tryRead (string, integer)");
                t4 = linda.tryRead(tsi);
                System.out.println("(3) tuple en sortie du tryRead: " + t4);
                System.out.println("(3) linda apres tryRead : " + linda.toString());
                
                System.out.println();
                
                System.out.println("(3) linda avant tryRead : " + linda.toString());
                System.out.println("tryTake "+t5);
                t4 = linda.tryRead(t5);
                System.out.println("(3) tuple en sortie du tryRead: " + t4);
                System.out.println("(3) linda apres tryRead : " + linda.toString());
                
                System.out.println();
                System.out.println("Pour take et read, les fonction sont bien bloquantes si le template n'existe pas.");
            }
        }.start();
                
    }
}
