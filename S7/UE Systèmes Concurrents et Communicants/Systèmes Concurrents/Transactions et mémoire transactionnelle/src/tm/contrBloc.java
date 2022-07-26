package tm;

import java.util.Map;
import java.util.HashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Set;
import java.util.HashSet;

// Mémoire transactionnelle avec contrôle de concurrence pessimiste : 
// verrouillage non bloquant, abandon en cas de conflit.
public class TMPP extends AbstractTM {

    // Map qui associe chaque t_objet au verrou qui en protège l'accès.
    private ConcurrentMap<String,TrySharedLock> locks;

    // Map qui associe chaque transaction à son journal des valeurs avant.
    private Map<String,Map<String,Integer>> oldVals;

    // Map qui associe chaque transaction à l'ensemble des t_objects qu'elle a lus.
    private Map<String,Set<String>> readSets;

    // Map qui associe chaque transaction à l'ensemble des t_objects qu'elle a écrits.
    private Map<String,Set<String>> writeSets;

    public ContrBloc() {

    }


    // Nettoie de la mémoire transactionnelle les valeurs liées à la transaction en argument.
    private void remove(String transaction) {

    }

    // Libère les verrous pris par une transaction 
    // et en nettoie les variables de la mémoire transactionnelle.
    private void unlock_all(String transaction) {

        
    }

    public boolean newTransaction(AbstractTransaction transaction) {

        
    }

    public int read(String id_transaction, String t_object) throws AbortException {

        
    }


    public void write(String id_transaction,
                      String t_object,
                      int value) throws AbortException {

       
    }


    public void abort(String id_transaction) throws AbortException {

        
    }


    public void commit(String id_transaction) throws AbortException {

    }
}
