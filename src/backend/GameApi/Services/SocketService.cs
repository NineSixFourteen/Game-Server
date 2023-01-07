public interface ISock {

    List<Socket> getList();
    void addSocket(Socket newSock);
}

public class Socker : ISock {

    public List<Socket> socks {get;set;} 

    public Socker(){
        socks = new List<Socket>();
    }

    public List<Socket> getList(){
        return socks;
    }

    public void addSocket(Socket newSock){
        socks.Add(newSock);
    }
}
