using System.Net;
using Microsoft.AspNetCore.Mvc;
using GamePlayer.Game;
namespace GameApi.Controllers;
[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase{

    private IUserService _userService;

    private readonly DataContext DBContext;

    public UserController(IUserService userServ, DataContext DBContext){
        _userService = userServ;
        this.DBContext = DBContext;
    }

    [HttpPost]
    public ActionResult<bool> AddUser(User user){
        if(_userService == null){
            return NotFound();
        }
        var result = _userService.AddUser(user);
        return result;
    }

    [HttpGet]
    public ActionResult<List<User>> GetUsers(){
        var List = DBContext.Users;
        var res = List.ToList();
        return res;
   }

   [HttpGet("GetUser")]
    public ActionResult<int> Get(){
        var List = DBContext.Games;
        DBContext.Games.Add(new Game());
        DBContext.SaveChanges();
        var x = List.Count();
        return x;
    }

}