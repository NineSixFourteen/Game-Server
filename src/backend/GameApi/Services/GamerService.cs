using GamePlayer.PlayableGame;
using GamePlayer.Game;
using GamePlayer.MyError;
using Helpers.Maybe;

public interface IGameService {

    Maybe<MyError> AddGame(Game game);
    List<Game> GetAllGames();
    Maybe<MyError> makeMove(int id, string move, string auth);
    Maybe<PlayableGame> getBoard(int id);
    Maybe<MyError> dropGame(int id);
}

public class GameServer : IGameService {
    private List<PlayableGame> games;

    public GameServer(){
        games = new List<PlayableGame>();
    }
    public Maybe<MyError> AddGame(Game game){
        Console.WriteLine(game.GameType);
        switch(game.GameType){
            case 1:
                var gm = new TicTacToe();
                var x = gm.fromGame(game);
                if(x is Maybe<MyError>.Some err){
                    return err;
                } else {
                    games.Add(gm);
                    return new Maybe<MyError>.None();
                }
            case 2: 
                var gms = new FourInARow();
                var xs = gms.fromGame(game);
                if(xs is Maybe<MyError>.Some errs){
                    return errs;
                } else {
                    games.Add(gms);
                    return new Maybe<MyError>.None();
                }
                break;
            default:
                return new Maybe<MyError>.Some(new ServiceError(1,"Game Type Unknown"));
        }
    }
    public Maybe<MyError> dropGame(int id){
        var game = games.Find(gam => gam.id == id);
        if(game != null){
            games.Remove(game);
        } else new Maybe<MyError>.Some(new ServiceError(5,"Game wasnt loaded"));
        return new Maybe<MyError>.None();
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