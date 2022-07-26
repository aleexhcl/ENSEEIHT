package linda.test;

import linda.*;
import linda.Linda.eventMode;
import linda.Linda.eventTiming;

public class testGeneral {
	
	private static class MyCallback implements Callback {
        public void call(Tuple t) {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
            }
            System.out.println();
            System.out.println("CALLBACK Got "+t);
            System.out.println();
        }
    }
	
	private static class MyCallback2 implements Callback {
        public void call(Tuple t) {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
            }
            System.out.println();
            System.out.println("CALLBACK2 Got "+t);
            System.out.println();
        }
    }

    public static void main(String[] a) {
                
        //final Linda linda = new linda.shm.CentralizedLinda2();
        final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
                
        new Thread() {
            public void run() {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                
                Tuple motif = new Tuple(Integer.class, String.class);
                linda.eventRegister(eventMode.TAKE, eventTiming.IMMEDIATE, motif, new MyCallback());
                
                Tuple motif2 = new Tuple(4, Integer.class);
                linda.eventRegister(eventMode.READ, eventTiming.IMMEDIATE, motif2, new MyCallback());
                
                Tuple motif3 = new Tuple(Integer.class, Integer.class);
                linda.eventRegister(eventMode.READ, eventTiming.FUTURE, motif3, new MyCallback2());

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
                
                System.out.println();
                
                System.out.println("(3) linda avant take : " + linda.toString());
                Tuple t4 = linda.take(new Tuple(String.class, Integer.class));
                System.out.println("(3) tuple en sortie du take: " + t4);
                System.out.println("(3) linda apres take : " + linda.toString());
                
                System.out.println("(2) write: " + t2);
                linda.write(t2);
                
                System.out.println();
                
                System.out.println("(3) linda avant read : " + linda.toString());
                t4 = linda.read(t2);
                System.out.println("(3) tuple en sortie du read: " + t4);
                System.out.println("(3) linda apres read : " + linda.toString());
                
                System.out.println();
                
                System.out.println("(3) linda avant tryTake : " + linda.toString());
                t4 = linda.tryTake(t2);
                System.out.println("(3) tuple en sortie du tryTake: " + t4);
                System.out.println("(3) linda apres tryTake : " + linda.toString());
                
                System.out.println("(2) write: " + t2);
                linda.write(t2);
                
                System.out.println();
                
                System.out.println("(3) linda avant tryRead : " + linda.toString());
                t4 = linda.tryRead(t2);
                System.out.println("(3) tuple en sortie du tryRead: " + t4);
                System.out.println("(3) linda apres tryRead : " + linda.toString());
                

            }
        }.start();
                
    }
}
