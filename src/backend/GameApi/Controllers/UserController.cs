using System.Net;
using Microsoft.AspNetCore.Mvc;
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
    public ActionResult<IEnumerable<User>> GetUsers(){
        if(_userService == null){
            return NotFound();
        }        var result = _userService.GetAllUsers().ToList();
        return result;
   }

   [HttpGet("GetUser")]
public ActionResult<int> Get(){
    var List = DBContext.Users;
    DBContext.Add<User>(new User());
    DBContext.Add<Game>(new Game());
    DBContext.SaveChanges();
    var x = List.Count();
    return x;
}

}