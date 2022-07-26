import java.rmi.*;
import java.rmi.registry.*;
import java.rmi.server.*;
import java.util.*;

public class CarnetImpl extends UnicastRemoteObject implements Carnet {

	private Map<String,RFiche> carnet;
	private int numServeur;
	private CarnetImpl autreCarnet;

    public CarnetImpl(int n) throws RemoteException {
    	carnet = new HashMap<String,RFiche>();
    	numServeur = n;
    	autreCarnet = null;
    }

    public void main(String args[]) {
    	try {
    		int n = Integer.parseInt(args[1]);
    		CarnetImpl serv = new CarnetImpl(n);
    		Registry registry = LocateRegistry.createRegistry(4000);
    		Naming.rebind("//localhost:4000/carnet"+n, serv);
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }

	public void Ajouter(SFiche sf) throws RemoteException {
		RFiche rf = new RFicheImpl(sf.getNom(), sf.getEmail());
		carnet.put(sf.getNom(), rf);
    }

	public RFiche Consulter(String n, boolean forward) throws RemoteException {
		try {
			RFiche rf = carnet.get(n);
			if (rf == null && forward) {
				if (autreCarnet == null) {
					autreCarnet = (CarnetImpl) Naming.lookup("//localhost:4000/carnet"+(3-numServeur));
				}
				rf = autreCarnet.Consulter(n, false);
			}
			return rf;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
