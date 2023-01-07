using Microsoft.AspNetCore.Mvc;
using System;
using GamePlayer.Game;
using System.Text;
using GamePlayer.MyError;
using GamePlayer.PlayableGame;
using Helpers.Maybe;
using System.Net.WebSockets;
using System.Collections.Generic;
using System.Threading.Tasks;


namespace GameApi.Controllers;

public class WebSocketController : ControllerBase{

    private ISock _Sock;

    public WebSocketController(ISock sock){
        _Sock = sock;
    }

    [Route("/connect")]
    public async Task Get(String User){
        Socket soc = new Socket(User);
        _Sock.addSocket(soc);
        await soc.AddSocket(HttpContext);
        Console.WriteLine(_Sock.getList().ToArray().Length );
    }

    [Route("/Test")]
    public async Task Rec(String mes){
        if(_Sock.getList().ToArray().Length > 0){
        await _Sock.getList()[0].SendMessage(mes);
        } else{
            Console.WriteLine("No Socks");
        }
    }
    
    [Route("/Test2")]
    public void  Recc(){
        if(_Sock.getList().ToArray().Length > 0){
            _Sock.getList()[0].PrintMessages();
        } else{
            Console.WriteLine("No Socks");
        }
    }


}