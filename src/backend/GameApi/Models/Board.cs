public class GameStatus {
    public GameStatus(int type, string st, int tu, int win, bool gamdo, string[] plrs,int[] photos){
        this.type = type;
        state = st;
        turn = tu;
        winner = win;
        isGameDone = gamdo;
        players = plrs;
        this.photos = photos;
    }
    public int type {get;set;}
    public string state {get;set;}
    public int turn {get;set;}
    public int winner {get;set;}
    public bool isGameDone{get;set;}
    public string[] players{get;set;}
    public int[] photos{get;set;}
}