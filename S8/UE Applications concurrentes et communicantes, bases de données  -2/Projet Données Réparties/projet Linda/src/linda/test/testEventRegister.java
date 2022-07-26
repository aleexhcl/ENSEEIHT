package linda.test;

import linda.Callback;
import linda.Linda;
import linda.Tuple;
import linda.Linda.eventMode;
import linda.Linda.eventTiming;

public class testEventRegister {
	
	private static class MyCallback implements Callback {
        public void call(Tuple t) {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
            }
            System.out.println();
            System.out.println("CALLBACK1 take + immediate Got "+t);
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
            System.out.println("CALLBACK2 read + immediate Got "+t);
            System.out.println();
        }
    }
	
	private static class MyCallback3 implements Callback {
        public void call(Tuple t) {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
            }
            System.out.println();
            System.out.println("CALLBACK3 read + future Got "+t);
            System.out.println();
        }
    }
	
	private static class MyCallback4 implements Callback {
        public void call(Tuple t) {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
            }
            System.out.println();
            System.out.println("CALLBACK4 take + future Got "+t);
            System.out.println();
        }
    }
	
	private static class MyCallback5 implements Callback {
        public void call(Tuple t) {
            try {
                Thread.sleep(1);
            } catch (InterruptedException e) {
            }
            System.out.println();
            System.out.println("CALLBACK5 read + immediate Got "+t);
            System.out.println();
        }
    }
	
	public static void main(String[] a) {
        
        //final Linda linda = new linda.shm.CentralizedLinda2();
        //final Linda linda = new linda.server.LindaClient("//localhost:4000/Linda");
        //final Linda linda2 = new linda.server.LindaClient("//localhost:4000/Linda");
		final Linda linda = new linda.multiserver.LindaMultiClient("//localhost:4050/LindaMulti"); 
                
        new Thread() {
            public void run() {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("Une phrase en 'doit avoir' décrit ce que l'on attend d'avoir avant cette phrase.");
                System.out.println();
                
                System.out.println("linda : " + linda.toString()); 
                System.out.println("doit avoir rien (pas de write encore fait)");
                
                System.out.println();
                
                Tuple motif = new Tuple(Integer.class, String.class);
                linda.eventRegister(eventMode.TAKE, eventTiming.IMMEDIATE, motif, new MyCallback());
                //linda2.eventRegister(eventMode.TAKE, eventTiming.IMMEDIATE, motif, new MyCallback());
                
                System.out.println("TAKE > test du take");
                //linda.take(new Tuple(1,1,1,1));
                System.out.println("linda : " + linda.toString()); 
                System.out.println("WRITE");
                linda.write(new Tuple(1,1));
                System.out.println("write fin");
                
                
                linda.write(new Tuple(2,1,1,1)); 
                System.out.println("linda : " + linda.toString()); 
                
                Tuple t1 = new Tuple(4, 5);
                System.out.println("(2) write: " + t1);
                linda.write(t1);
                System.out.println("linda : " + linda.toString()); 
                
                Tuple motif2 = new Tuple(4, Integer.class);
                linda.eventRegister(eventMode.READ, eventTiming.IMMEDIATE, motif2, new MyCallback2());
                Tuple motif5 = new Tuple(Integer.class, Integer.class);
                linda.eventRegister(eventMode.READ, eventTiming.IMMEDIATE, motif5, new MyCallback5());
                System.out.println("linda : " + linda.toString()); 
                System.out.println("doit avoir callback2 et callback5 et reste dans mémoire");
                System.out.println();
                
                Tuple motif3 = new Tuple(Integer.class, Integer.class);
                linda.eventRegister(eventMode.READ, eventTiming.FUTURE, motif3, new MyCallback3());
                System.out.println("doit avoir rien (enregistre future call sur (integer, integer))");
                System.out.println("linda : " + linda.toString()); 
                System.out.println();
                //linda2.write(t1);

                Tuple t11 = new Tuple(4, 9);
                System.out.println("(2) write: " + t11);
                linda.write(t11);
                System.out.println("linda : " + linda.toString()); 
                System.out.println("doit avoir callback3 et reste dans mémoire");
                System.out.println();

                Tuple t2 = new Tuple("hello", 15);
                System.out.println("(2) write: " + t2);
                linda.write(t2);
                Tuple motif4 = new Tuple(String.class, 15);
                linda.eventRegister(eventMode.TAKE, eventTiming.FUTURE, motif4, new MyCallback4());
                System.out.println("doit avoir renvoie rien (enregistre future call sur (string,15))");
                System.out.println("linda : " + linda.toString()); 
                System.out.println();

                Tuple t3 = new Tuple(4, "foo");
                System.out.println("(2) write: " + t3);
                linda.write(t3);
                System.out.println("linda : " + linda.toString()); 
                System.out.println("doit avoir callback1 et suppression dans memoire");
                System.out.println();
                
                Tuple t4 = new Tuple("test", 15);
                System.out.println("(2) write: " + t4);
                linda.write(t4);
                System.out.println("linda : " + linda.toString()); 
                System.out.println("doit avoir callback4 et suppression dans memoire");
                
            }
        }.start();
    }
}
