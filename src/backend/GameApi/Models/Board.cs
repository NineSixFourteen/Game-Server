public class GameStatus {
    public GameStatus(string st, int tu, int win, bool gamdo, string[] plrs){
        state = st;
        turn = tu;
        winner = win;
        isGameDone = gamdo;
        players = plrs;
    }
    public string state {get;set;}
    public int turn {get;set;}
    public int winner {get;set;}
    public bool isGameDone{get;set;}
    public string[] players{get;set;}
}