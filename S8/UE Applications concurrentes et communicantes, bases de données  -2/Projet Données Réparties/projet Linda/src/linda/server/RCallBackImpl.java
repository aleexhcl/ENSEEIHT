package linda.server;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

import linda.Callback;
import linda.Tuple;

public class RCallBackImpl extends UnicastRemoteObject implements RCallBack{

		private static final long serialVersionUID = 1L;
		private Callback cb;
		
		public RCallBackImpl(Callback callback) throws RemoteException {
			super();
			this.cb = callback;
		}


		@Override
		public void call(Tuple t) {
			cb.call(t);
	    }

}
