using GamePlayer.Game;
using GamePlayer.PlayableGame;
public class TicTacToe : PlayableGame{

    public TicTacToe(Game game) => fromGame(game);

    public int[]? board {get;set;}
    public bool playerTurn{get;set;}
    public string[]? players{get;set;}
    public string[]? playersAuths{get;set;}
    private bool valid;
    private int[]? getBoard(string state){
        if(state.Length != 9){
            valid = false;
            return null;
        }
        return state.ToCharArray().ToList().Select(
            letter => {
                if((int) letter > 50){
                    valid = false;
                }
                return (int) letter - 48;
            }
        ).ToArray<int>();
    }
    public bool isGameComplete(){
        return false;
    }
    public bool isValid(){
        return valid;
    }
    public void fromGame(Game game){
        valid = true;
        int[]? x = getBoard(game.State);
        playerTurn = game.turn == 0;
        players = game.players.Split(",");
        if(players.Length != 2){
            valid = false;
        }
        playersAuths = game.playersAuths.Split(",");
        if(playersAuths.Length != 2){
            valid = false;
        }
    }
    public bool makeMove(string move, string auth){
        return false;
    }
    public Game? toGame(){
        if(valid == false){
            return null;
        }
        return new Game(
            1,
            toState(board),
            String.Join(", ",players),
            String.Join(", ",playersAuths)
        );
    }

    private string? toState(int[]? board){
        if(board == null){
            return null;
        }
        return board.ToList().Select(
            num =>  (char) num + 48
        ).ToString();
    }
}