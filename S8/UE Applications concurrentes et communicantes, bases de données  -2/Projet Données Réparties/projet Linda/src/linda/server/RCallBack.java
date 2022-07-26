package linda.server;

import java.rmi.Remote;
import java.rmi.RemoteException;

import linda.Tuple;

public interface RCallBack extends Remote {
	
	/** Callback when a tuple appears. 
     * See Linda.eventRegister for details.
     * 
     * @param t the new tuple
     */
    void call(Tuple t) throws RemoteException;

}
