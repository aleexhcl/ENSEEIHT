package linda.server;

import java.rmi.RemoteException;

import linda.Callback;
import linda.Tuple;

public class ServerCallBack implements Callback {
	
	private RCallBack cb;
	
	public ServerCallBack(RCallBack callback) {
		super();
		this.cb = callback;
	}
		
	@Override
	public void call(Tuple t) {
		try {
			cb.call(t);
		} catch(RemoteException e) {
			e.printStackTrace();
		}
		
	}

}
