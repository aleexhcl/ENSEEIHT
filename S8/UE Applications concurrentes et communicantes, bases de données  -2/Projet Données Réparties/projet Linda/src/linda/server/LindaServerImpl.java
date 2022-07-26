package linda.server;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Collection;

import linda.Tuple;
import linda.shm.CentralizedLinda;
import linda.Linda;
import linda.Linda.eventMode;
import linda.Linda.eventTiming;

public class LindaServerImpl extends UnicastRemoteObject implements LindaServer {
	
	private static final long serialVersionUID = 1L;
	private CentralizedLinda centralized; 
	
	public LindaServerImpl () throws RemoteException {
		super();
		centralized = new CentralizedLinda();
	}
	
	public LindaServerImpl (Linda linda) throws RemoteException {
		super();
		centralized = (CentralizedLinda) linda;
	}
	
	@Override
	 public void write(Tuple t) throws RemoteException {
		 this.centralized.write(t);
	 }

	@Override
     public Tuple take(Tuple template) throws RemoteException {
    	 return this.centralized.take(template);
     }

	@Override
     public Tuple read(Tuple template) throws RemoteException {
    	 return this.centralized.read(template);
     }

	@Override
    public Tuple tryTake(Tuple template) throws RemoteException {
    	return this.centralized.tryTake(template);
    }

	@Override
    public Tuple tryRead(Tuple template) throws RemoteException {
    	return this.centralized.tryRead(template);
    }

	@Override
    public Collection<Tuple> takeAll(Tuple template) throws RemoteException {
    	return this.centralized.takeAll(template);
    }

	@Override
    public Collection<Tuple> readAll(Tuple template) throws RemoteException {
    	return this.centralized.readAll(template);
    }

	@Override
    public void eventRegister(eventMode mode, eventTiming timing, Tuple template, RCallBack callback) throws RemoteException {
		ServerCallBack cb = new ServerCallBack (callback);
    	this.centralized.eventRegister(mode, timing, template, cb);
    }

	@Override
    public void debug(String prefix) throws RemoteException {
    	this.centralized.debug(prefix);
    }
	
}
