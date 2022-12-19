namespace GamePlayer.PlayableGame;
using GamePlayer.Game;
public interface PlayableGame {

    public bool isValid();
    public void fromGame(Game game);
    public bool makeMove(string move,string auth);
    public bool isGameComplete();
    public Game? toGame();

}

