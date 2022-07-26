package linda.server;

import java.rmi.*;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.util.*;

import linda.Callback;
import linda.Linda;
import linda.Tuple;

/** Client part of a client/server implementation of Linda.
 * It implements the Linda interface and propagates everything to the server it is connected to.
 * */
public class LindaClient implements Linda {

    private static LindaServer serveur;
	private ArrayList<Tuple> cache;	
	
    /** Initializes the Linda implementation.
     *  @param serverURI the URI of the server, e.g. "rmi://localhost:4000/LindaServer" or "//localhost:4000/LindaServer".
     */
    public LindaClient(String serverURI) {
		this.cache = new ArrayList<Tuple>();
        try { 
        	
        	Registry registry = LocateRegistry.getRegistry(getHost(serverURI), Integer.parseInt(getPort(serverURI)));
        	this.serveur = (LindaServer) registry.lookup("Linda");
        	
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public String getHost(String uri) {
		String host;
    	if (uri.startsWith("rmi")) {
			String[] parts = uri.split(":");
			parts = parts[1].split(":");
			host = parts[0].replace("//", "");
		} else {
			String[] parts = uri.split(":");
			host = parts[0].replace("//", "");
		}
    	return host;
    	
    }
    
    public String getPort(String uri) {
		String port;
		if (uri.startsWith("rmi")) {
			String[] parts = uri.split(":");
			parts = parts[1].split(":");
			parts = parts[1].split("/");
			port = parts[0];
		} else {
			String[] parts = uri.split(":");
			parts = parts[1].split("/");
			port = parts[0];
		}
    	return port;
    }

    @Override
    public void write(Tuple t){ 
		this.cache.add(t);
    	try {
			this.serveur.write(t);
			
		} catch (RemoteException e) {
			e.printStackTrace();
		}
    }

    @Override
    public Tuple take(Tuple template){
    	Tuple t = new Tuple();
        try {
			t= this.serveur.take(template);
		} catch (RemoteException e) {
			e.printStackTrace();
		} 
        return t;
    }

    @Override
    public Tuple read(Tuple template){
		Tuple t = new Tuple();

		for(Tuple tuple : cache) {
			if(tuple.matches(template)){
				t = tuple.deepclone();
				System.out.print("lu depuis le cache : ");
				return t; //Qu'une instance
			}
		}
		//Si on trouve ce qu'on cherche dans le cache on envoie pas de requête serveur
		try {
			t = this.serveur.read(template);
		} catch (RemoteException e) {
			e.printStackTrace();
		} 
		return t;
		
    }

    @Override
    public Tuple tryTake(Tuple template){
    	Tuple t = new Tuple();
    	try {
			t = this.serveur.tryTake(template);
		} catch (RemoteException e) {
			e.printStackTrace();
		} 
    	return t;
    }


    public Tuple tryRead(Tuple template){
    	Tuple t = new Tuple();

		for(Tuple tuple : cache) {
			if(tuple.matches(template)){
				t = tuple.deepclone();
				System.out.print("lu depuis le cache : ");
				return t; //Qu'une instance
			}
		}
		//Si on trouve ce qu'on cherche dans le cache on envoie pas de requête serveur
    	try {
			t = this.serveur.tryRead(template);
		} catch (RemoteException e) {
			e.printStackTrace();
		} 
    	return t;
    }

    @Override
    public Collection<Tuple> takeAll(Tuple template){
    	Collection<Tuple> res = new ArrayList<Tuple>();
    	try {
    		res = this.serveur.takeAll(template);
		} catch (RemoteException e) {
			e.printStackTrace();
		}
		return res;
    }

    @Override
    public Collection<Tuple> readAll(Tuple template){
    	Collection<Tuple> res = new ArrayList<Tuple>();
    	try {
			res = this.serveur.readAll(template);
		} catch (RemoteException e) {
			e.printStackTrace();
		}
    	return res;
    }

    @Override
    public void eventRegister(eventMode mode, eventTiming timing, Tuple template, Callback callback){
    	try {
    		RCallBack cb = new RCallBackImpl (callback);
			this.serveur.eventRegister(mode, timing, template, cb);
		} catch (RemoteException e) {
			e.printStackTrace();
		}
    }

    @Override
    public void debug(String prefix){
    	try {
			this.serveur.debug(prefix);
		} catch (RemoteException e) {
			e.printStackTrace();
		}
    }
}
