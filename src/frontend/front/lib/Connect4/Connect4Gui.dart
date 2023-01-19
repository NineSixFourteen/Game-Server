// ignore_for_file: no_logic_in_create_state, use_key_in_widget_constructors, must_be_immutable, empty_catches, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'Board4.dart';
import 'package:http/http.dart' as http;

class Connect4 extends StatefulWidget {
  Connect4(this.board, this.auth,this.playerNum,this.socket,this.isMobile);
  Board4 board;
  int playerNum;
  String auth;
  bool isMobile;
  WebSocketChannel socket;
  @override
  State<Connect4> createState() {
      return _Connect4(board.id, board.players, auth, 1, board.turn == playerNum, board.board, board.gameDone, board.winner,socket, isMobile);
  }
}

class _Connect4 extends State<Connect4> {
  _Connect4(this.id,this.players,this.auth,this.playerNum,this.turn, this.board, this.gameDone,this.winner,this.socket, this.isMobile){
    AddListener();
  }
  bool isMobile;
  int id; 
  List<String> players;
  String auth;
  int playerNum;
  bool turn;
  List<List<int>> board;
  int winner;
  bool gameDone;
  WebSocketChannel socket;
  
  List<bool> hovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  Future<void> sendMove(int move) async {
    socket.sink.add(getMessage(move));
  }

  getMessage(int move) {
    return "$id,$move,$auth";
  }

  void AddListener() async{
      socket.stream.listen(
      (data) {
        print(data);
        String msg = "$data";
        List<String> msgs = msg.split(",");
        setState(() {
          board = toBoard(msgs[0]);
          turn = playerNum == int.parse(msgs[1]);
          gameDone = msgs[2] == "true";
          winner = int.parse(msgs[3]);
        });

      },
      onError: (error) => print(error),
    );
  }

  void updateHover(int row, bool val){
    setState(() {
      hovering[row] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget wid = Column(
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 30) ,child: makeDisplay(players,winner,gameDone,turn,id,isMobile)),
                makeConnect4Board(board,sendMove, updateHover, hovering,playerNum,isMobile)
              ]);
    if(isMobile){
      wid = ListView(
        scrollDirection: Axis.horizontal,
        children: [
          SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(0, 10, 0, 30) ,child: makeDisplay(players,winner,gameDone,turn,id,isMobile)),
                makeConnect4Board(board,sendMove, updateHover, hovering,playerNum,isMobile)
              ],
            ),
          )
        ],
    );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false, // Disable back button
        leading: //re add back button 
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:(){
             //socket.sink.close();
             Navigator.pop(context);
            }
          ),
        title: const Align(
          alignment: Alignment.center,
          child:Text('Connect4',textAlign: TextAlign.center,) 
          )
      ),
      backgroundColor: const Color.fromARGB(150, 19, 2, 46),
      body: wid);
  }
  
  getBoard(int i) async { 
    try{
      final GameResponse = await http
        .get(Uri.parse('http://139.162.210.205/GameSev/Game/Get?id=$i'));
      if(GameResponse.statusCode == 200){
        if(GameResponse.body != ""){
          Board4 bor = Board4.fromJson(jsonDecode(GameResponse.body),i);
          setState(() { 
            players = bor.players;
            board = bor.board;
          });
        }}
      } on Exception{ }
    }
    
  List<List<int>> toBoard(String msg) {
    List<int> chars = List.from(msg.codeUnits);
    List<List<int>> board = List.generate(7, (_) => List.generate(7, (_) => 0));
    for(int i = 0; i < 7;i++){
      for(int j = 0;j < 7;j++){
        board[6 - i][j] = chars[(i * 7) + j] - 48;
      }
    }
    return board;
  } 
}

Widget makeConnect4Board(List<List<int>> board, Function func, Function hover, List<bool> hovers,int playerNum, bool isMobile) {
  double padding = 20;
  if(isMobile){
    padding = 10;
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 19, 2, 46),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(padding: EdgeInsets.all(padding), child:Row(children: List.generate(7, (i) => i + 1).map((row) {
         return makeRow(board, row - 1,func,hover,hovers,playerNum, isMobile);
        }).toList())))]
    
  );
}

Widget makeRow(List<List<int>> board, int row, Function func, Function hover, List<bool> hovers,int playerNum, bool isMobile) {
  int ind = -1; 
  if(hovers[row]){
    ind = findFirstEmpty(board, row);
  }
  return TextButton(
  onHover: (t) => {
    hover(row, t)
  },
  style:  ButtonStyle(
    shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide(color: Colors.black)
    )),
    overlayColor: MaterialStatePropertyAll(Colors.blue.withOpacity(0.6)),
    backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 17, 7, 107))
  ) ,
  onPressed: (){ func(row);}, 
  child:
    Column(
      children: List.generate(7, (i) => i + 1).map((til) => tile(til - 1, func, row, board,til -1 == ind,playerNum, isMobile)).toList(),
    ));
}

int findFirstEmpty(List<List<int>> board, int row) {
  for(int col = 6; col > 0;col--){
    if(board[col][row] == 0){
      return col;
    }
  }
  return -1;
}

Widget tile(int col, Function func, int row, List<List<int>> board, bool show,int playerNum, bool isMobile){
  Color tileColour; 
  int value = board[col][row];
  double width = 80;
  double height = 60;
  double padding = 10;
  if(isMobile){
    padding = 4;
    width = 40;
    height = 50;
  }
  switch(value){
    case 1:
      tileColour = Colors.yellow;
      break;
    case 2:
      tileColour = Colors.red; 
      break;
    default:
      tileColour = Colors.white; 
  } 
  if(playerNum == 2){
    tileColour = show ? Colors.red.withOpacity(0.6) : tileColour; 
  } else {
    tileColour = show ? Colors.yellow.withOpacity(0.6) : tileColour;
  }
  return Padding(
    padding: EdgeInsets.all(padding),
    child:SizedBox(
    width: width,
    height: height,
    child: Container(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        border: Border.all(width: 2 , color: const Color.fromARGB(255, 0, 102, 255)),
        color: tileColour,
        shape: BoxShape.circle
      ),
      
    ),
  ));
}

Widget makeDisplay(List<String> players, int winner, bool gameDone, bool turn, int id, bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInfo(1, players[0], 2, isMobile),
          playerInfo(2, players[1], 4, isMobile)
        ],
  );
}

Widget playerInfo(int playerNum, String player, int photo, bool isMobile) {
  Color playerColour;
  double fontsize = 30;
  double width = 200;
  if(isMobile){
    fontsize = 20;
    width = 100;
  }
  if(playerNum == 2){
    playerColour = Colors.red;
  } else {
    playerColour = Colors.yellow;
  }
  return Row(
    children:[
      Image.asset("assets/images/$photo.png", width: width, height: 100),
      Column(
        children: [
          Text(player, style: TextStyle(color: Colors.white, fontSize: fontsize)),
          Container(
          width: width/5,
          height: width/5,
          decoration: BoxDecoration(
            color: playerColour,
            shape: BoxShape.circle,
          ))
        ]),
      ]);
}