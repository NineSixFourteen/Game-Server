using Microsoft.AspNetCore.Mvc;
using System;
using GamePlayer.Game;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;
using Helpers.Maybe;
namespace GameApi.Controllers;

[ApiController]
[Route("[controller]")]
public class GameController: ControllerBase{
    private IGameService _gameService;
    private ITrack Tracker;
    private readonly DataContext DBContext;
    public GameController(IGameService gameService, DataContext DBContext, ITrack tracker){
        _gameService = gameService;
        this.DBContext = DBContext;
        Tracker = tracker;
    }
    [HttpGet("Load")]
    public ActionResult<string> load(int id){
        if(!Tracker.getList().Contains(id)){
            Tracker.addID(id);
            Console.WriteLine(id);
            var x = loadGame(id);
            if(x is Maybe<MyError>.Some error){
                return new ActionResult<string>(error.Value.getError());
            } else return new ActionResult<string>("Game Loaded");
        } else return "Game already loaded";

    }
    [HttpGet("Drop")]
    public ActionResult<string> dropGame(int id){
        if(Tracker.getList().Contains(id)){
            saveGames();
            var x = _gameService.dropGame(id);
            if(x is Maybe<MyError>.Some err){
                return err.Value.getError();
            } else {
                return "Game Dropped";
            }
        } else return "Could not drop as isnt loaded";
    }
    [HttpGet("Save")]
    public ActionResult<String> saveGames(){
        var curr = _gameService.GetAllGames();
        foreach (Game game in curr){
            var x= DBContext.Games.SingleOrDefault(gam => gam.Id == game.Id);
            if(x != null){
                x.State = game.State;
                x.turn = game.turn;
                DBContext.SaveChanges();
            }
        }
        return "Saved";
    }
    private Maybe<MyError> loadGame(int id){
        var game = DBContext.Games.ToList().Find(p => p.Id == id);
        if(game != null){
            DBContext.Games.Update(game); 
            var result = _gameService.AddGame(game);
            if(result is Maybe<MyError>.Some  error){
                return error;
            } else return new Maybe<MyError>.None();
        } else return new Maybe<MyError>.Some(new ServiceError(2,"Game not found"));
    }
    [HttpGet("Create")]
    public ActionResult<string> createGame(int type, string players){
        if(_gameService == null){
            return NotFound();
        }
        DBContext.Games.Add(new Game(0,1,"000000000","Test1, player1","SxPxTtZQ, p64lPhBr",0));
        DBContext.SaveChanges();
        var game = DBContext.Games.OrderByDescending(p => p.Id).FirstOrDefault();  
        if(game != null){
            var result = _gameService.AddGame(game);
            if(result is Maybe<MyError>.Some  error){
                return new ActionResult<string>(error.Value.getError());
            }

        } else{
            return new ActionResult<string>("Error cant find new game");
        }
        return new ActionResult<string>("Game has been added");
    }
    [HttpGet]
    public ActionResult<List<Game>> GetGames(){
        return new ActionResult<List<Game>>(_gameService.GetAllGames().ToList());
   }
   [HttpGet("Get")]
    public ActionResult<GameStatus> Get(int id){
        if(_gameService == null){
            return NotFound();
        }
        var x = _gameService.getBoard(id);
        if(x is Maybe<PlayableGame>.Some game){
            if(game.Value.toGame() is Maybe<Game>.Some gam){
                var ga = gam.Value;
                return new GameStatus(
                    ga.State, ga.turn,
                    game.Value.getWinner(), game.Value.isGameComplete(), 
                    ga.players.Split(", ").ToArray());
            }    
        } else {
            load(id);
            return Get(id);
        }
        return NotFound();
    }
    [HttpGet("MakeMove")]
    public ActionResult<string> makeMove(int id, string move, string auth){
        if(Tracker.getList().FirstOrDefault(ids => ids == id) != 0){
            var x = _gameService.makeMove(id,move,auth);
            if(x is Maybe<MyError>.Some z){
                return z.Value.getError();
            } else {
                return "Move Made";
            }
        } else {
            var x = loadGame(id);
            if(x is Maybe<MyError>.Some err){
                return err.Value.getError();
            } else {
                var y = _gameService.makeMove(id,move,auth);
                if(y is Maybe<MyError>.Some z){
                    return z.Value.getError();
                } else {
                    return "Move Made";
                }
            }
        }
    }
}