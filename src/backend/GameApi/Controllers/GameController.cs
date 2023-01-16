using Microsoft.AspNetCore.Mvc;
using System.Web;
using System.Net.WebSockets;
using System;
using System.Text;
using GamePlayer.Game;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;
using Helpers.Maybe;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace GameApi.Controllers;

[ApiController]
[Route("[controller]")]
public class GameController: ControllerBase{
    private ISock _Sock;
    private IGameService _gameService;
    private ITrack Tracker;
    private readonly DataContext DBContext;
    public GameController(IGameService gameService, DataContext DBContext, ITrack tracker, ISock sock ){
        _gameService = gameService;
        this.DBContext = DBContext;
        Tracker = tracker;
        _Sock = sock;
    }
    [HttpGet("Load")]
    public ActionResult<string> load(int id){
        if(!Tracker.getList().Contains(id)){
            Tracker.addID(id);
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
            Console.WriteLine("RR" + game.GameType);
            Console.WriteLine("LL" + game.State);
            if(result is Maybe<MyError>.Some  error){
                Console.WriteLine("22" + game.State);
                Console.WriteLine(error.Value.getError());
                Console.WriteLine("22" + game.State);
                return error;
            } else return new Maybe<MyError>.None();
        } else return new Maybe<MyError>.Some(new ServiceError(2,"Game not found"));
    }
    [HttpGet("Create")]
    public ActionResult<string> createGame(int type, string players){
        if(_gameService == null){
            return NotFound();
        }
        if(type == 2|| type == 1){
            String playerAuths = getPlayerAuths(players);
            if(playerAuths == ""){
                return "Error not players";
            }
            Game ga = new Game(0,type,"",players,playerAuths,0);
            DBContext.Games.Add(ga);
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
        } else{
            return "Not sssssdsdsds";
        }
    }

    private string getPlayerAuths(string players){
        try{
            string[] pls = players.Split(", ");
            string ret = "";
            foreach(string str in pls){
                Console.WriteLine(str);
                ret += DBContext.Users.ToList()
                        .Where(user => user.Name == str)
                        .Select(user => user.Token)
                        .ToList()[0] + ", ";
            }
            return ret.Substring(0, ret.Length - 2);
        } catch (Exception){
            return "";
        }
    }

    [HttpGet]
    public ActionResult<List<Game>> GetGames(){
        return new ActionResult<List<Game>>(_gameService.GetAllGames().ToList());
    }


    private GameStatus? getGame(int id){
        var x = _gameService.getBoard(id);
        if(x is Maybe<PlayableGame>.Some game){
            if(game.Value.toGame() is Maybe<Game>.Some gam){
                var ga = gam.Value;
                return new GameStatus(
                    ga.GameType,
                    ga.State, ga.turn,
                    game.Value.getWinner(), game.Value.isGameComplete(), 
                    ga.players.Split(", ").ToArray(),new int[]{2,3});
            }  else {
                return null;
            }
        } else {
            if(loadGame(id) is Maybe<MyError>.Some){
                return null;
            }
            return getGame(id);
        }
    }

    [HttpGet("Gets/{Ids}")]
    public ActionResult<List<GameStatus>> GetGames(String ids){
        String[] nums = ids.Split(",");
        List<GameStatus> ret = new List<GameStatus>();
        Console.WriteLine(ids);
        foreach(String id in nums){
            GameStatus g = getGame(Int32.Parse(id));
            Console.WriteLine(g.state);
            ret.Add(getGame(Int32.Parse(id)));
        }   
         return ret;
    }
   [HttpGet("Get")]
    public ActionResult<GameStatus> Get(int id){
        if(_gameService == null){
            return NotFound();
        }
        var x = getGame(id);
        if(x == null){
            return NotFound();
        }
        return x;
    }

    private string makeMove(int id, string move, string auth){
        Console.WriteLine(id);
        if(Tracker.getList().FirstOrDefault(ids => ids == id) != 0){
            var x = _gameService.makeMove(id,move,auth);
            if(x is Maybe<MyError>.Some z){
                return z.Value.getError();
            } else {
                return "Move Made";
            }
        } else {
            load(id);
            var y = _gameService.makeMove(id,move,auth);
            if(y is Maybe<MyError>.Some z){
                return z.Value.getError();
            } else {
                return "Move Made";
            }
        }
    }   

    //Socket Stuff
    [Route("/connect")]
    public async Task Conne(int id){
        Socket soc = new Socket("");
        _Sock.addSocket(id,soc);
        Console.WriteLine($"Socket added to {id}");
        try{
            if (HttpContext.WebSockets.IsWebSocketRequest){
                using var webSocket = await HttpContext.WebSockets.AcceptWebSocketAsync();
                soc.AddSocket(webSocket);
                if(soc.Sock != null){
                    await Listen(soc.Sock);
                }
            } else {
                HttpContext.Response.StatusCode = StatusCodes.Status400BadRequest;
            }
        } catch(Exception e) {
            Console.WriteLine(e);
            Console.WriteLine($"Socket closed on {id}");
            if(soc.Sock != null){
                await soc.Sock.CloseOutputAsync(WebSocketCloseStatus.NormalClosure, string.Empty, CancellationToken.None);
            }
        }
        Console.WriteLine(_Sock.getLookup().Count );
    }

    private async Task Listen(WebSocket webSocket){
        byte[] buffer = new byte[1056];
        while (webSocket.State == WebSocketState.Open){
            var result = await webSocket.ReceiveAsync(buffer, CancellationToken.None);
            if (result.MessageType == WebSocketMessageType.Close){
                Console.WriteLine("Close Socket on Sever");
                await webSocket.CloseOutputAsync(WebSocketCloseStatus.NormalClosure, null, CancellationToken.None);
            } else{
                
                String mes = Encoding.ASCII.GetString(buffer, 0, result.Count);
                Console.WriteLine("Message Got - " + mes );
                String[] items = mes.Split(",");
                int id = Int32.Parse(items[0]);
                string s = makeMove(id, items[1], items[2]);
                if(s == "Move Made"){
                    if(_gameService.getBoard(id) is Maybe<PlayableGame>.Some game){
                        Console.WriteLine("Trying to send message");
                        if(!await _Sock.SendOut(id, game.Value)){
                            Console.WriteLine("Failed to send");
                        }
                    }else {
                        Console.WriteLine("Fail2");
                    }
                } else {
                    Console.WriteLine("Fail - " + s);
                }
            }
        }
    }

}