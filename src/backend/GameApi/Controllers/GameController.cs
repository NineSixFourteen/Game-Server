using System.Net;
using Microsoft.AspNetCore.Mvc;
using GamePlayer.Game;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;
using Helpers.Maybe;
namespace GameApi.Controllers;

[ApiController]
[Route("[controller]")]
public class GameController: ControllerBase{
    private IGameService _gameService;
    private readonly DataContext DBContext;
    public GameController(IGameService gameService, DataContext DBContext){
        _gameService = gameService;
        this.DBContext = DBContext;
    }
    [HttpPost]
    public ActionResult<string> AddGame(Game game){
        if(_gameService == null){
            return NotFound();
        }
        var result = _gameService.AddGame(game);
        if(result is Maybe<MyError>.Some  error){
            return new ActionResult<string>(error.Value.getError());
        }
        return new ActionResult<string>("Game has been added");
    }
    [HttpGet("Load")]
    public ActionResult<string> load(int id){
        var x = loadGame(id);
        if(x is Maybe<MyError>.Some error){
            return new ActionResult<string>(error.Value.getError());
        } else return new ActionResult<string>("Game Loaded");
    }
    private string saveGames(){
        var curr = _gameService.GetAllGames();
        var orig = _gameService.GetOriginals();
        for(int i = 0; i < curr.Count();i++){
            orig[i]= curr[i];
        }
        DBContext.SaveChanges();
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
        DBContext.Games.Add(new Game(0,1,"000000011","player 3, player 4","auth1, auth2",0));
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
   [HttpGet("GetUser")]
    public ActionResult<int> Get(){
        var List = DBContext.Games;
        DBContext.Games.Add(new Game());
        DBContext.SaveChanges();
        var x = List.Count();
        return x;
    }
    [HttpGet("MakeMove")]
    public ActionResult<string> makeMove(int id, string move, string auth){
        var x = _gameService.makeMove(id,move,auth);
        if(x is Maybe<MyError>.Some z){
            return z.Value.getError();
        } else {
            return "Move Made";
        }
    }
}