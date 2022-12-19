
public class Game {

    public Game(){
        Id = 0;
        GameType = 0;
        State = "01010101010101010";
        players = "test1, test2";
    }
    public int Id {get; set;}
    public int GameType {get; set;}
    public string State {get; set;}
    public string players {get; set;}
    public int turn {get; set;}
}