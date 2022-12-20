namespace GamePlayer.PlayableGame;
using GamePlayer.Game;
using GamePlayer.MyError;
using Helpers.Maybe;
public interface PlayableGame {
    public Maybe<MyError> fromGame(Game game);
    public Maybe<MyError> makeMove(string move,string auth);
    public bool isGameComplete();
    public int getWinner();
    public Maybe<Game> toGame();
    public string display();
    public string getState();
    
}

