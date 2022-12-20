using GamePlayer.PlayableGame;
using GamePlayer.Game;
using GamePlayer.MyError;
using Helpers.Maybe;
public interface IGameService {

    List<Game> GetOriginals();
    Maybe<MyError> AddGame(Game game);
    List<Game> GetAllGames();
    Maybe<MyError> makeMove(int id, string move, string auth);
    Maybe<PlayableGame> getBoard(int id);
}

public class GameServer : IGameService {
    private List<PlayableGame> games;
    private List<Game> originals;

    public GameServer(){
        games = new List<PlayableGame>();
    }
    public Maybe<MyError> AddGame(Game game){
        switch(game.GameType){
            case 1:
                var gm = new TicTacToe();
                var x = gm.fromGame(game);
                if(x is Maybe<MyError>.Some err){
                    return err;
                } else {
                    games.Add(gm);
                    originals.Add(game);
                    return new Maybe<MyError>.None();
                }
            default:
                return new Maybe<MyError>.Some(new ServiceError(1,"Game Type Unknown"));
        }
    }
    public List<Game> GetAllGames(){
        List<Game> gams = new List<Game>();
        games.ForEach(game => {
            if(game.toGame() is Maybe<Game>.Some x){
                gams.Add(x.Value);
            }
        });
        return gams;
    }

    public Maybe<PlayableGame> getBoard(int id){
        Maybe<PlayableGame> MayGame = GetGame(id);
        if(MayGame is Maybe<PlayableGame>.Some game){
            return new Maybe<PlayableGame>.Some(game.Value);
        } else{
            return new Maybe<PlayableGame>.None();
        }
    }

    public List<Game> GetOriginals(){
        return originals;
    }

    public Maybe<MyError> makeMove(int id,string move, string auth){
        Maybe<PlayableGame> MayGame = GetGame(id);
        if(MayGame is Maybe<PlayableGame>.Some game){
            var x = game.Value;
            var mov = x.makeMove(move, auth);
            return mov; 
        }else{
            return new Maybe<MyError>.Some(new ServiceError(2,"Game not found"));
        }
    }

    private Maybe<PlayableGame> GetGame(int id){
        var x = games.Find(game => game.id == id);
        if(x != null){
            return new Maybe<PlayableGame>.Some(x);
        } else {
            return new Maybe<PlayableGame>.None();
        }
    }
}