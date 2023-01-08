
using System;
using System.Text;
using System.Net.WebSockets;
using System.Threading.Tasks;
using GameApi.Controllers;
using System.Collections.Generic;
using Helpers.Maybe;
using System.Threading;
using GamePlayer.Game;
using GamePlayer.PlayableGame;

public class Socket {

    public String User {get;set;}
    public WebSocket? Sock {get;set;}

    public Socket(String user){
        User = user;
        Sock = null;
    }
    public void AddSocket(WebSocket socket){
        Sock = socket;
    }

        private async Task Echo(WebSocket webSocket){
        var buffer = new byte[1024 * 4];
        while (webSocket.State == WebSocketState.Open){
            var result = await webSocket.ReceiveAsync(buffer, CancellationToken.None);
            if (result.MessageType == WebSocketMessageType.Close){
                await webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, null, CancellationToken.None);
            } else{
                String mes = Encoding.ASCII.GetString(buffer, 0, result.Count);
                Console.WriteLine(mes);
            }
        }
    }

    public async Task SendMessage(String message){
        if(Sock != null){
            if(Sock.State == WebSocketState.Open){
                byte[] data = Encoding.ASCII.GetBytes(message);
                await Sock.SendAsync(data, WebSocketMessageType.Text, 
                    true, CancellationToken.None);
            }
        }
    }

    public async Task<bool> SendBoard(PlayableGame game){
        if(Sock != null){
            if(Sock.State == WebSocketState.Open){
                String message = makeMessage(game);
                if(message != ""){
                    byte[] data = Encoding.ASCII.GetBytes(message);
                    await Sock.SendAsync(data, WebSocketMessageType.Text, true, CancellationToken.None);
                    return true;
                }
            }
        }
        return false;
    }

    public String makeMessage(PlayableGame game){
        var gam = game.toGame();
        if(gam is Maybe<Game>.Some ga){
            String message = "";
            message += ga.Value.State + ",";
            message += ga.Value.turn + ",";
            message += game.isGameComplete() + "," + game.getWinner();
            return message;
        } else {
            return "";
        }

    }


}