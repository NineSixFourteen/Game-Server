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
  Column MiddleBit;
  double fontSize;
  List<double> widths;
  if(isMobile){
    widths = [90,60,100,120];
    fontSize = 20;
    MiddleBit = Column(
      children: [
        const Text("Vs       ",style: TextStyle(color: Colors.white, fontSize: 25)),
        Text(player,style: const TextStyle(color: Colors.white, fontSize: 20)),

    ]);
  } else {
    widths = [200,250,390,130];
    fontSize = 40;
    MiddleBit = Column(
      children: [
        Row(children: [Text("  Vs $player",style: const TextStyle(color: Colors.white, fontSize: 31))]),
        Row(children: [Text("       Moves Made $moves",style: const TextStyle(color: Colors.white, fontSize: 26))])
    ]);
  }
  Color color;
  Text text;
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
      text = Text( "Your Turn",style: TextStyle(color: const Color.fromARGB(255, 15, 2, 44), fontSize: fontSize));
    } else {
     text = Text( "Opponent Turn",style: TextStyle(color: const Color.fromARGB(255, 134, 8, 8), fontSize: fontSize));
    }
    color = const Color.fromARGB(255, 19, 187, 230);
  }
  return Padding(
    padding: const EdgeInsets.fromLTRB(0,10,0,5),
    child:ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
      ),
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
                ShowBoard(board.board,isMobile)
            ])
            ),
    ]),
      onPressed: () => {loadGame(board.id, context,glob.auth,glob.user, isMobile)},
  ));
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

Widget ShowBoard(List<int> board, bool isMobile) {
  Widget wid;
  double width;
  double height;
  if(isMobile){
    width = 40;
    height = 25 ;
  }  else {
    width = 40;
    height = 25;
  } 
  if(board.length == 9){
    wid = Row(
      children: [
        Column(
          children: [
            smallTile(board[0],width,height),
            smallTile(board[3],width,height),
            smallTile(board[6],width,height)
          ],
        ),
        Column(
          children: [
            smallTile(board[1],width,height),
            smallTile(board[4],width,height),
            smallTile(board[7],width,height)
          ],
        ),
        Column(
          children: [
            smallTile(board[2],width,height),
            smallTile(board[5],width,height),
            smallTile(board[8],width,height)
          ],
        )
      ],
    );
  } else{
    wid = const Text("Connect4", style: TextStyle(color: Colors.red),);
  }
  return wid;
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

Widget smallTile(int val, double width, double height){
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
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.left,
        ))
      );
}