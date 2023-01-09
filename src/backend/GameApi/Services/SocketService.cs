using System.Collections.Generic;
using GamePlayer.PlayableGame;

public interface ISock {

    Dictionary<int,List<Socket>> getLookup();
    Task<bool> SendOut(int id, PlayableGame game);
    void addSocket(int id, Socket newSock);
}

public class Socker : ISock {

    public Dictionary<int,List<Socket>> Lookup {get;set;} 

    public Socker(){
        Lookup = new Dictionary<int,List<Socket>>();
    }

    public async Task<bool> SendOut(int id, PlayableGame game){
        bool ret = true;
        foreach(Socket sock in Lookup[id]){
            if(!await sock.SendBoard(game)){
            }
        }
        return ret;
    }

    public Dictionary<int,List<Socket>> getLookup(){
        return Lookup;
    }

    public void addSocket(int id, Socket newSock){
        if(Lookup.ContainsKey(id)){
            Lookup[id].Add(newSock);
        } else {
            List<Socket> socs = new List<Socket>();
            socs.Add(newSock);
            Lookup[id] = socs;
        }
    }
}
