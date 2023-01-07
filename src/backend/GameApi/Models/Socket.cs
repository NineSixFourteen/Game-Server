
using System;
using System.Text;
using System.Net.WebSockets;
using System.Threading.Tasks;
using GameApi.Controllers;
using System.Collections.Generic;

public class Socket {

    public String User {get;set;}
    public WebSocket? Sock {get;set;}

    public List<String> Messages {get;set;}
    public Socket(String user){
        User = user;
        Messages = new List<string>();
        Sock = null;
    }
    public async Task AddSocket(HttpContext context){
        Console.WriteLine("Connection - " + User);
        try{
            if (context.WebSockets.IsWebSocketRequest){
                using var webSocket = await context.WebSockets.AcceptWebSocketAsync();
                Sock = webSocket;
                await Echo(webSocket);   
            } else {
                context.Response.StatusCode = StatusCodes.Status400BadRequest;
            }
        } catch(Exception) {
            Console.WriteLine("Closed Socket - " + User);
        }
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
                Messages.Add(mes);
            }
        }
    }

    public void PrintMessages(){
        Console.WriteLine(Messages.Count);
        foreach(String str in Messages){
            Console.WriteLine(str);
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


}