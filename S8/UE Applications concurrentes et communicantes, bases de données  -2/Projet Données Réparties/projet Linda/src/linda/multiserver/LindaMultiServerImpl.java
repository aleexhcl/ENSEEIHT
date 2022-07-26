package linda.multiserver;

import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.ArrayList;
import java.util.Collection;

import linda.Linda;
import linda.Tuple;
import linda.Linda.eventMode;
import linda.Linda.eventTiming;
import linda.server.LindaServerImpl;
import linda.server.RCallBack;

public class LindaMultiServerImpl extends LindaServerImpl implements LindaMultiServer {
	
	private static final long serialVersionUID = 1L;

	public LindaMultiServerImpl() throws RemoteException {
		super();
	}

	@Override
	public void write(Tuple t) throws RemoteException {
		// TODO Auto-generated method stub
		super.write(t);
	}

	@Override
	public Tuple take(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		return super.take(template);
	}

	@Override
	public Tuple read(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		return super.read(template);
	}

	@Override
	public Tuple tryTake(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		return super.tryTake(template);
	}

	@Override
	public Tuple tryRead(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		return super.tryRead(template);
	}

	@Override
	public Collection<Tuple> takeAll(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		return super.takeAll(template);
	}

	@Override
	public Collection<Tuple> readAll(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		return super.readAll(template);
	}

	@Override
	public void eventRegister(eventMode mode, eventTiming timing, Tuple template, RCallBack callback)
			throws RemoteException {
		// TODO Auto-generated method stub
		super.eventRegister(mode, timing, template, callback);
	}

	@Override
	public void debug(String prefix) throws RemoteException {
		// TODO Auto-generated method stub
		super.debug(prefix);
	}

	
}
