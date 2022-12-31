using System;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using GamePlayer.Game;
using Helpers.Info;
using System.Security.Cryptography;
namespace GameApi.Controllers;
[ApiController]
[Route("[controller]")]
public class UserController : ControllerBase{
    private readonly DataContext DBContext;
    private List<User> Users; 
    public UserController(DataContext DBContext){
        this.DBContext = DBContext;
        Users = DBContext.Users.ToList();
    }

    [HttpGet("/Create")]
    public ActionResult<string> AddUser(String name, String password){
        String str = "";
        Users.ForEach( 
            user => {
                if(name == user.Name){
                    str = "Name already used";
                }
            }
        );
        if(str == ""){
            User newUser = new User(name,HashString(password, Info.Salt), randomString(8));
            DBContext.Users.Add(newUser);
            DBContext.SaveChanges();
            return "User Created";
        } else {
            return str;
        }
    }
    [HttpGet("/Games")]
    public ActionResult<List<int>> getGames(string name, string auth){
        var user = Users.Find(user => user.Name == name);
        if(user != null){
            if(user.Token == auth){
                return (DBContext.Games.ToList()
                                .Where(game => game.players.Split(", ")
                                .Contains(name))
                                .Select(game => game.Id)
                                .ToList());
            } else return (new List<int>());
        } else return (new List<int>());
    }
    [HttpGet("/Login")]
    public ActionResult<string> login(string name, string pass){
        var user = Users.Find( x => x.Name == name && x.Pass == HashString(pass, Info.Salt));
        if(user == null){
            return "Error: User not found";
        } else {
            return user.Token;
        }
    }
    private string randomString(int Length){
        var random = new Random();
        var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        var stringChars = new char[Length];
        for (int i = 0; i < stringChars.Length; i++){
            stringChars[i] = chars[random.Next(chars.Length)];
        }
        return new string(stringChars);
    }
    private static string HashString(string text, string salt = ""){
        if (String.IsNullOrEmpty(text)){
            return String.Empty;
        }
        using (var sha = SHA256.Create()){
            byte[] textBytes = System.Text.Encoding.UTF8.GetBytes(text + salt);
            byte[] hashBytes = sha.ComputeHash(textBytes);
            string hash = BitConverter
                .ToString(hashBytes)
                .Replace("-", String.Empty);
            return hash;
        }
    }
}