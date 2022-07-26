package linda.multiserver;

import java.rmi.AccessException;
import java.rmi.AlreadyBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.Collection;

import linda.Linda.eventMode;
import linda.Linda.eventTiming;
import linda.Tuple;
import linda.server.RCallBack;

public class ServLoadBalancer extends UnicastRemoteObject implements LindaMultiServer {

	private static final long serialVersionUID = 1L;
	private ArrayList<LindaMultiServer> serveursExistants = new ArrayList<LindaMultiServer>();
	private int nbServers = 3;
	private int port = 4050; 
	Registry registry; 
	Tuple res = new Tuple() ; 
	
	public ServLoadBalancer() throws RemoteException {
		super();
		//registry= LocateRegistry.createRegistry(port);
		try {
			//registry.bind("LindaMulti", new LindaMultiServerImpl());
		
			for(int i=1;i<nbServers+1;i++) {
				//creation des serveurs 
				try {
					Registry registryServ = LocateRegistry.createRegistry(port+i);
					String servURIServ = "//:localhost:" + Integer.toString(port+i) + "/LindaMulti"; 
					LindaMultiServer lms = new LindaMultiServerImpl();
					registryServ.bind(servURIServ, lms);
					
					serveursExistants.add(lms); 
				} catch (Exception e) {
					e.printStackTrace();
				} 
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	public ServLoadBalancer(int nbServers) throws RemoteException {
		super();
		this.nbServers = nbServers; 
		for(int i=1;i<nbServers+1;i++) {
			//creation des serveurs 
			try {
				Registry registry = LocateRegistry.createRegistry(port+i);
				String servURI = "//:localhost:" + Integer.toString(port+i) + "/LindaMulti"; 
				LindaMultiServer lms = new LindaMultiServerImpl();
				registry.bind(servURI, lms);
				
				serveursExistants.add(lms); 
			} catch (Exception e) {
				e.printStackTrace();
			} 
			
		}
	}

	@Override
	public void write(Tuple t) throws RemoteException {
		// TODO Auto-generated method stub
		
		int n = t.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		serveursExistants.get(ind_port).write(t);
		
	}

	@Override
	public Tuple take(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		return serveursExistants.get(ind_port).take(template);
	}

	@Override
	public Tuple read(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		return serveursExistants.get(ind_port).read(template); 
	}

	@Override
	public Tuple tryTake(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		return serveursExistants.get(ind_port).tryTake(template); 
	}

	@Override
	public Tuple tryRead(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		return serveursExistants.get(ind_port).tryRead(template);
	}

	@Override
	public Collection<Tuple> takeAll(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		return serveursExistants.get(ind_port).takeAll(template);
	}

	@Override
	public Collection<Tuple> readAll(Tuple template) throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		return serveursExistants.get(ind_port).readAll(template);
	}

	@Override
	public void eventRegister(eventMode mode, eventTiming timing, Tuple template, RCallBack callback)
			throws RemoteException {
		// TODO Auto-generated method stub
		int n = template.size(); 
		int ind_port = n%nbServers; 
		System.out.println(port+ind_port+1); 
		serveursExistants.get(ind_port).eventRegister(mode, timing, template, callback); 
		
	}

	@Override
	public void debug(String prefix) throws RemoteException {
		// TODO Auto-generated method stub
		
	}
}
