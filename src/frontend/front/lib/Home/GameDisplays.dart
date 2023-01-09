// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Shared/Data.dart';
import 'package:http/http.dart' as http;
import '../TicTac/TicBoard.dart';
import '../TicTac/TicTacGui.dart';

Widget DisplayGame(Board board, Data glob,MediaQueryData data, BuildContext context){
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
  double width;
  double nameWidth;
  if(data.size.width < data.size.height){
    width = data.size.  width / 1.3;
    nameWidth = (width/5) * 1.6;
    fontSize = 20;
    MiddleBit = Column(
      children: [
        const Text("Vs       ",style: TextStyle(color: Colors.white, fontSize: 25)),
        Text(player,style: const TextStyle(color: Colors.white, fontSize: 20)),

    ]);
  } else {
    width = data.size.width / 1.4;
    nameWidth = (width/5) * 2;
    fontSize = 50;
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
            width: width/5,
            height: 100,
            child: Image.asset("assets/images/$photo.png")
            ),
          SizedBox(
            width: (width/5)*1.3,
            height: 80,
            child: MiddleBit
            ),
          SizedBox(
            width: nameWidth,
            height: 75,
            child: Column(
              children:  [
                text
            ])
          ),
          SizedBox(
            width:  120,
            height: 75,
            child: Column(
              children: [
                ShowBoard(board.board,data)
            ])
            ),
    ]),
      onPressed: () => {loadGame(board.id, context,glob.auth,glob.user)},
  ));
}

void loadGame(int gameID, BuildContext context, String auth, String name) async{
    try{
      final channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:5083/connect?id=$gameID'),
      );
      final GameResponse = await http
        .get(Uri.parse('http://localhost:5083/Game/Get?id=$gameID'));
      if(GameResponse.statusCode == 200){
        if(GameResponse.body != ""){
          Board bor = Board.fromJson(jsonDecode(GameResponse.body),gameID);
          int playerNum = getPlayer(bor,name);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => 
              TicToeGame(id:gameID, auth:auth,socket: channel, 
                board: bor.board, gameDone: bor.gameDone, playerNum: playerNum,
                players: bor.players, turn: bor.turn == playerNum, winner: bor.winner
              )),
          );
        }
      }

    } catch(_){

    }

}

int getPlayer(Board bor, String name) {
  for(int i =0; i< 2;i++){
    if(bor.players[i] == name){
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

Widget ShowBoard(List<int> board, MediaQueryData data) {
  Widget wid;
  double width;
  double height;
  if(data.size.width < data.size.height){
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