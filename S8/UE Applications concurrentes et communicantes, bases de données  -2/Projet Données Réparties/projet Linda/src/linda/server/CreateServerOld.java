package linda.server;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class CreateServerOld {
	
	public static void main(String[] a) {	
		
    	try {
    		Registry registry = LocateRegistry.createRegistry(4000);
    		registry.bind("Linda", new LindaServerImpl()); 
    	}
    		catch (Exception e) { e.printStackTrace();
    	}
    }

}
