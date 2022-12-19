using System.Net;
using Microsoft.AspNetCore.Mvc;
namespace GameApi.Controllers;
[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase{

    private IUserService _userService;

    public UserController(IUserService userServ){
        _userService = userServ;
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


}