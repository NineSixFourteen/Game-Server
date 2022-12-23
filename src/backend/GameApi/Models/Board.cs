public class Board {

    public Board(string st, int tu, int win, bool gamdo){
        state = st;
        turn = tu;
        winner = win;
        isGameDone = gamdo;
    }
    public string state {get;set;}
    public int turn {get;set;}
    public int winner {get;set;}
    public bool isGameDone{get;set;}
}