using GamePlayer.PlayableGame;
using GamePlayer.Game;
using GamePlayer.MyError;
using Helpers.Maybe;
public interface ITrack {

    List<int> getList();
    void addID(int id);
}

public class Tracker : ITrack {

    public List<int> ids {get;set;} 

    public Tracker(){
        ids = new List<int>();
    }

    public List<int> getList(){
        return ids;
    }

    public void addID(int id){
        ids.Add(id);
    }
}
