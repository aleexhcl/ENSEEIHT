package linda.multiserver;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class CreateMultiServer {
	
public static void main(String[] a) {	
		
    	try {
    		Registry registry = LocateRegistry.createRegistry(4050);
    		registry.bind("LindaMulti", new ServLoadBalancer()); 
    	}
    		catch (Exception e) { e.printStackTrace();
    	}
    }

}
