import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class RFicheImpl extends UnicastRemoteObject implements RFiche {
	private static final long serialVersionUID = 1;
	String fnom;
	String fmail;
	
	public RFicheImpl(String n, String m) throws RemoteException {
		fnom = n;
		fmail = m;
	}
	
	public String getNom () throws RemoteException {
		return fnom;
	}
	public String getEmail () throws RemoteException {
		return fmail;
	}
}
