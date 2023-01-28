// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/Connect4/Board4.dart';
import 'package:front/Connect4/Connect4Gui.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Shared/Data.dart';
import 'package:http/http.dart' as http;
import '../TicTac/TicBoard.dart';
import '../TicTac/TicTacGui.dart';

Widget OtherView(Board board, Data glob, bool isMobile, BuildContext context,){
  String player = "";
  List<String> players = board.players;
  int emm = 0;
  int moves = getMoves(board.board);
  int photo = 0;
  for(int i = 0; i < 2;i++){
    if(players[i] != glob.user){
      player = players[i];
      emm = i == 1 ? 0 : 1;
      photo = board.photos[i];
    }
  }
  Column MiddleBit;
  double fontSize;
  List<double> widths;
  Color color;
  Text text;
  if(isMobile){
    widths = [80,60,90,120];
    fontSize = 20;
    MiddleBit = Column(
      children: [
        const Text("Vs       ",style: TextStyle(color: Colors.white, fontSize: 25)),
        Text(player,style: const TextStyle(color: Colors.white, fontSize: 20)),

    ]);
  } else {
    widths = [200,250,390,130];
    fontSize = 50;
    MiddleBit = Column(
      children: [
        Row(children: [Text(player,style: const TextStyle(color: Colors.white, fontSize: 32))]),
        Row(children: [Text("Moves Made $moves",style: const TextStyle(color: Colors.white, fontSize: 28))])
    ]);
  }
  if(board.gameDone){
    if(board.winner == emm + 1){
      color = const Color.fromARGB(255, 18, 204, 27);
      text = Text( "Victory",style: TextStyle(color: Colors.black, fontSize: fontSize));
    } else if(board.winner == -1){
      text = Text( "Draw",style: TextStyle(color: Colors.black, fontSize: fontSize));
      color = const Color.fromARGB(255, 63, 17, 65);
    } else {
      text = Text( "Defeat",style: TextStyle(color: Colors.black, fontSize: fontSize));
      color = const Color.fromARGB(255, 223, 11, 11);
    }
  } else {
    if(board.turn == emm ){
      text = Text( "Your Turn",style: TextStyle(color: const Color.fromARGB(255, 8, 10, 161), fontSize: fontSize));
    } else {
     text = Text( "Opponent Turn",style: TextStyle(color: const Color.fromARGB(255, 134, 8, 8), fontSize: fontSize));
    }
    color = const Color.fromARGB(255, 19, 187, 230);
  }
  return Padding(
    padding: const EdgeInsets.all(10),
    child:ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
      ),
      onPressed: () { 

       },
      child:  Row(
        children: [
          SizedBox(
            width: widths[0],
            height: 100,
            child: Image.asset("assets/images/$photo.png")
            ),
          SizedBox(
            width: widths[1],
            height: 80,
            child: MiddleBit
            ),
          SizedBox(
            width: widths[2],
            height: 75,
            child: Column(
              children:  [
                text
            ])
          ),
          SizedBox(
            width:  widths[3],
            height: 75,
            child: Column(
              children: [
                ShowBoard(board.board,isMobile, false)
            ])
            ),
    ])));
}

Widget DisplayGame(Board board, Data glob, bool isMobile,BuildContext context){
  String player = "";
  List<String> players = board.players;
  int emm = 0;
  int moves = getMoves(board.board);
  int photo = 0;
  for(int i = 0; i < 2;i++){
    if(players[i] != glob.user){
      player = players[i];
      emm = i == 1 ? 0 : 1;
      photo = board.photos[i];
    }
  }
  Color color;
  Text text;
  double fontSize = 40;
  if(isMobile){
    fontSize = 25;
  }
  if(board.gameDone){
    if(board.winner == emm + 1){
      color = const Color.fromARGB(255, 18, 204, 27);
      text = Text( "Victory",style: TextStyle(color: Colors.black, fontSize: fontSize));
    } else if(board.winner == -1){
      text = Text( "Draw",style: TextStyle(color: Colors.black, fontSize: fontSize));
      color = const Color.fromARGB(255, 63, 17, 65);
    } else {
      text = Text( "Defeat",style: TextStyle(color: Colors.black, fontSize: fontSize));
      color = const Color.fromARGB(255, 223, 11, 11);
    }
  } else {
    if(board.turn == emm ){
      text = Text( "Your Turn",style: TextStyle(color: const Color.fromARGB(255, 8, 10, 161), fontSize: fontSize));
    } else {
     text = Text( "Opponent Turn",style: TextStyle(color: const Color.fromARGB(255, 134, 8, 8), fontSize: fontSize));
    }
    color = const Color.fromARGB(255, 19, 187, 230);
  }
  return Padding(
    padding: const EdgeInsets.all(10),
    child:ElevatedButton(
      style: TextButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size.zero, // Set this
          padding: EdgeInsets.zero, // and this
        ),
      child: GameDis(board,text,moves,player, photo, isMobile, color),
      onPressed: () => {loadGame(board.id, context,glob.auth,glob.user, isMobile)},
  ));
}

Widget GameDis(Board board, Text text, int moves, String player, int photo, bool isMobile, Color color) {
  double width = 350;
  double height = 350;
  if(isMobile){
    width = 185;
    height = 200;
  }
  return SizedBox(
    width: width,
    height: height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        text,
        GameBoard(board, isMobile),
        GameInfo(board, isMobile, text,photo,player,color)
      ]),
  );
}

Widget GameInfo(Board board, bool mobile, Text text, int photo, String player, Color col) {
  double width = 400;
  double height = 97;
  double fontSize = 50;
  if(mobile){
    width = 200;
    height = 71;
    fontSize = 40;
  }
  Color color = const Color.fromARGB(255, 5, 141, 209);
  if(col != const Color.fromARGB(255, 19, 187, 230)){
    color = col;
  }
  return SizedBox(
    width: width,
    height: height,
    child: Container(
      decoration: BoxDecoration(color: color),
      child: 
        Row(
          children:[
          SizedBox(
              width: mobile ? 70: 130,
              height: height,
              child: Image.asset("assets/images/$photo.png")
            ),
          Text(player, style: TextStyle(color: Colors.white, fontSize: fontSize),)
      ])
    )
  );
  
}

Widget GameBoard(Board board, bool mobile) {
  double width = 400;
  double height = 200;
  if(mobile){
    width = 200;
    height = 100;
  }
  return SizedBox(
    width: width,
    height: height,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
        Container(
      decoration: const BoxDecoration(color: Color.fromARGB(255, 86, 10, 158)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ShowBoard(board.board, mobile,true)))])]),
  );
}

void loadGame(int gameID, BuildContext context, String auth, String name, bool isMobile) async{
    try{
      final channel = WebSocketChannel.connect(
        Uri.parse('ws://139.162.210.205/GameSev/connect?id=$gameID'),
      );
      final GameResponse = await http
        .get(Uri.parse('http://139.162.210.205/GameSev/Game/Get?id=$gameID'));
      if(GameResponse.statusCode == 200){
        if(GameResponse.body != ""){
          var x = jsonDecode(GameResponse.body);
          if(x['type'] == 1){
          Board bor = Board.fromJson(jsonDecode(GameResponse.body),gameID);
          int playerNum = getPlayer(bor.players,name);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => 
              TicToeGame(id:gameID, auth:auth,socket: channel, 
                board: bor.board, gameDone: bor.gameDone, playerNum: playerNum,
                players: bor.players, turn: bor.turn == playerNum, winner: bor.winner, isMobile: isMobile,
              )),
          );
        } else if(x['type'] == 2){
          Board4 bor = Board4.fromJson(jsonDecode(GameResponse.body),gameID);
          int playerNum = getPlayer(bor.players,name);
          print("FAISL");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => 
              Connect4(bor, auth, playerNum, channel,isMobile)),);
        }else {
          print(x);
        }} 
      }
    } catch(Exception){
      print("FAISL");
    }

}

int getPlayer(List<String> players, String name) {
  for(int i =0; i< 2;i++){
    if(players[i] == name){
      return i == 0 ? 1 : 2; 
    }
  }
  return 0;
}

int getMoves(List<int> board) {
  int moves =0;
  for(int i =0 ;i < board.length;i++){
    if(board[i] != 0){
      moves++;
    }
  }
  return moves; 
}

Widget ShowBoard(List<int> board, bool isMobile, bool view) {
  Widget wid;
  double width;
  double height;
  double fontSize;
  if(view){
    if(isMobile){
      width = 40;
      height = 25 ;
      fontSize = 15;
    }  else {
      width = 70;
      height = 60;
      fontSize = 35;
    }
  } else {
    if(isMobile){
      width = 40;
      height = 25;
      fontSize = 20;
    }  else {
      width = 40;
      height = 25;
      fontSize = 16;
    }
  }
  if(board.length == 9){
    wid = Row(
      children: [
        Column(
          children: [
            smallTile(board[0],width,height,fontSize),
            smallTile(board[3],width,height,fontSize),
            smallTile(board[6],width,height,fontSize)
          ],
        ),
        Column(
          children: [
            smallTile(board[1],width,height,fontSize),
            smallTile(board[4],width,height,fontSize),
            smallTile(board[7],width,height,fontSize)
          ],
        ),
        Column(
          children: [
            smallTile(board[2],width,height,fontSize),
            smallTile(board[5],width,height,fontSize),
            smallTile(board[8],width,height,fontSize)
          ],
        )
      ],
    );
  } else{
    if(view){
      wid = Row(children: [0,1,2,3,4,5,6].map((e) => Connect4SmallRow(board,e,isMobile)).toList());
    } else {
      wid = const Text("Connect4", style: TextStyle(color: Colors.black, fontSize: 20),);
    }
  }
  return wid;
}

Widget Connect4SmallRow(List<int> board, int row, bool isMobile) {
  double width = 35;
  double height = 25;
  if(isMobile){
    width = 10;
    height = 10;
  }
  return Container(
    child:Column(
      children: [6,5,4,3,2,1,0].map(
        (e) => SizedBox(
          width: width,
          height: height,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2 , color: const Color.fromARGB(255, 0, 102, 255)),
              shape: BoxShape.circle,
              color: getColour(board[row + e * 7])
            )),
        )).toList()
  ));



}

Color getColour(int board) {
  if(board == 0){
    return Colors.blue;
  } else if(board == 1){
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

BoxDecoration backG(Color color){
  return const 
    BoxDecoration(
      color: Colors.blueGrey  ,
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0,0),
          blurRadius: 4.0,
          spreadRadius: 4.0
      )]
    );
}

Widget smallTile(int val, double width, double height,double fontSize){
  const red = MaterialStatePropertyAll<Color>(Colors.red);
  const blue = MaterialStatePropertyAll<Color>(Colors.blue);
  var color = MaterialStatePropertyAll<Color>(Colors.grey[500]!);
  var msg = " ";
  if(val == 2){
    color = red;
    msg = "X";
  } else if(val == 1){
    color = blue;
    msg = "O";
  }
  return SizedBox(
    height: height,
    width:  width,
    child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: color,
        ),
        onPressed: () => {}, 
            child: Text(
              msg,
              style: TextStyle(fontSize: fontSize, color: Colors.white),
              textAlign: TextAlign.left,
        ))
      );
}