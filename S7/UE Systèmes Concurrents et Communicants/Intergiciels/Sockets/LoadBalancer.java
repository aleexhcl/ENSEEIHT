package tp1;
import java.net.*;
import java.util.Random;
import java.io.*;


public class LoadBalancer extends Thread {
    static String hosts[] = {"localhost", "localhost"};
    static int ports[] = {8081,8082};
    static int nbHosts = 2;
    static Random rand = new Random();
    
    private Socket s; 
    

    public LoadBalancer(Socket ss) {
		this.s = ss; 
	}

    public void run() {
    	try {
    	
    	int nbport = rand.nextInt(nbHosts);
    	Socket s_port = new Socket(hosts[nbport],ports[nbport]);
    	
    	OutputStream s_out = s.getOutputStream();
    	InputStream s_in = s.getInputStream();
    	OutputStream s_port_out = s_port.getOutputStream();
    	InputStream s_port_in = s_port.getInputStream();
    	
    	//buffer lect 
    	byte[] buff = new byte[1024];
    	int nbBytesLus;
    	
    	//msg serv vers cli
    	
    	nbBytesLus = s_in.read(buff);
    	s_port_out.write(buff, 0, nbBytesLus);
    	
    	//msg cli vers serv
    	nbBytesLus = s_port_in.read(buff);
    	s_out.write(buff, 0, nbBytesLus);
       
    	
    	s.close();
    	s_port.close();
    	s_out.close();
    	s_in.close();
    	s_port_out.close();
    	s_port_in.close();
    	}
    	catch (Exception e ) {System.out.println("fin");}
    	
    }


	public static void main (String[] args) {
		try {
        ServerSocket servs = new ServerSocket(8083);
        while (true) {
            Thread t = new LoadBalancer(servs.accept());
            t.start();
        }
		} catch (Exception e) { e.printStackTrace();}
    }

} 
