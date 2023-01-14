// ignore_for_file: no_logic_in_create_state, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class Connect4 extends StatefulWidget {
  Connect4();
  List<List<int>> fakeBoard = 
  [
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0],
    [0,0,0,1,0,0,0],
    [1,0,0,2,0,0,0],
    [1,0,0,2,0,0,0],
    [1,0,2,2,0,0,0]
  ];

  @override
  State<Connect4> createState() => _Connect4(0,["Fake1","Fake2"], "Auth1",0, true, fakeBoard, false, -1);
}

class _Connect4 extends State<Connect4> {
  _Connect4(this.id,this.players,this.auth,this.playerNum,this.turn, this.board, this.gameDone,this.winner);
  int id; 
  List<String> players;
  String auth;
  int playerNum;
  bool turn;
  List<List<int>> board;
  int winner;
  bool gameDone;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
          children: [
            Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 30) ,child: makeDisplay(players,winner,gameDone,turn,id)),
            makeConnect4Board(board,(){})//Todo move func
          ]
          ),
      );
  }
}

Widget makeConnect4Board(List<List<int>> board, Function func) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 19, 2, 46),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(padding: const EdgeInsets.all(20), child:Row(children: List.generate(7, (i) => i + 1).map((row) {
         return makeRow(board, row - 1,func);
        }).toList())))]
    
  );
}

Widget makeRow(List<List<int>> board, int row, Function func) {
  return TextButton(
  style:  ButtonStyle(
    shape: MaterialStateProperty.all(
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide(color: Colors.black)
    )),
    overlayColor: MaterialStatePropertyAll(Colors.blue.withOpacity(0.6)),
    backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(255, 17, 7, 107))
  ) ,
  onPressed: (){}, 
  child:
    Column(
      children: List.generate(7, (i) => i + 1).map((til) => tile(til - 1, func, row, board)).toList(),
    ));
}

Widget tile(int col, Function func, int row, List<List<int>> board){
  Color tileColour; 
  int value = board[col][row];
  switch(value){
    case 1:
      tileColour = Color.fromARGB(255, 255, 230, 0);
      break;
    case 2:
      tileColour = Colors.red; 
      break;
    default:
      tileColour = Colors.white; 
  }  
  return Padding(
    padding: const EdgeInsets.all(10),
    child:SizedBox(
    width: 80,
    height: 60,
    child: Container(
      // ignore: prefer_const_constructors
      decoration: BoxDecoration(
        border: Border.all(width: 2 , color: Color.fromARGB(255, 0, 102, 255)),
        color: tileColour,
        shape: BoxShape.circle
      ),
      
    ),
  ));
}

Widget  makeDisplay(List<String> players, int winner, bool gameDone, bool turn, int id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          playerInfo(0, players[0], 2),
          playerInfo(1, players[1], 4)
        ],
  );
}

Widget playerInfo(int playerNum, String player, int photo) {
  Color playerColour;
  if(playerNum == 0){
    playerColour = Colors.red;
  } else {
    playerColour = Colors.yellow;
  }
  return Row(
    children:[
      Image.asset("assets/images/$photo.png", width: 200, height: 100),
      Column(
        children: [
          Text(player, style: const TextStyle(color: Colors.white, fontSize: 30)),
          Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            color: playerColour,
            shape: BoxShape.circle,
          ))
        ]),
      ]);
}