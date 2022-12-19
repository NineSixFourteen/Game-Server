namespace GamePlayer.Game;
public class Game {

    //Dummy Func
    public Game(){
        Id = 0;
        GameType = 0;
        State = "010101010110";
        players = "test132, test22";
        playersAuths = "auth12, auth22";
    }
    public Game(int gameType, string state, string Players, string PlayersAuths ){
        Id = 0;
        GameType = gameType;
        State = state;
        players = Players;
        playersAuths = PlayersAuths;
    }
    public int Id {get; set;}
    public int GameType {get; set;}
    public string State {get; set;}
    public string players {get; set;}
    public string playersAuths {get; set;}
    public int turn {get; set;}
}