import 'dart:async';
import 'dart:convert';

import 'package:front/TicBoard.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicToeGame(id: 4),
    );
  }
}
Future<http.Response> fetchGame() async {
  return await http.get(Uri.parse('http:localhost/Game/get'));
}
// ignore: must_be_immutable
class TicToeGame extends StatefulWidget {
  TicToeGame({super.key,required this.id});
  int id;
  @override
  // ignore: no_logic_in_create_state
  State<TicToeGame> createState() => _TicToeGame(id, [],0,true,"1, 2", "auth1",0,false);
}
class _TicToeGame extends State<TicToeGame> {
  int id; 
  String players;
  String auth;
  int playerNum;
  bool turn;
  List<int> board;
  int winner;
  bool gameDone;
  // ignore: type_init_formals
  _TicToeGame(this.id, this.board,this.playerNum,this.turn,this.players,this.auth,this.winner,this.gameDone){
    board = [0,0,0,1,1,0,0,0,0,0,0];
    winner = -1;
    gameDone = false;
    getBoard();
  }

  void update(int val){
      switch(board[val]){
      case 0: 
        board[val] = playerNum;
        sendMove(val);
        break;
    }

    setState(() {
      board = board;
    });
  }

  Future<void> sendMove(int move) async {
      final Response = await http.get(Uri.parse(
        "http://localhost:5083/Game/makeMove?id=$id&move=$move&auth=$auth"
      ));
  }

  void getBoard(){
    Timer.periodic(const Duration(seconds: 5), 
      (timer) async {
        try{
          final response = await http
                .get(Uri.parse('http://localhost:5083/Game/Get?id=$id'));
          if(response.statusCode == 200){
            var x = Board.fromJson(jsonDecode(response.body));
            setState(() {
                board = x.board;
                winner = x.winner;
                gameDone = x.gameDone;
                turn = true;
              });
          } else 
            print("lsso $response.body");
        } catch(Exception){
          print(Exception);
        }
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:(){}
          )
        ],
        title: const Align(
          alignment: Alignment.center,
          child:Text('Tic Tac Toe',textAlign: TextAlign.center,) 
          )
      ),
      backgroundColor: Colors.black45,
      body: Column(
          children: [
            _buildPointsTable(players.split(", ")),
            grid(board,update)
          ]
          ),
    );
  }
}
Text displayTex(String message){
  return Text(message,
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Colors.white, 
              fontSize: 35,
            )
  );
}
Widget tile(List<int> board, int pos, Function onTap){
  var val = board[pos];
  const red = MaterialStatePropertyAll<Color>(Colors.red);
  const blue = MaterialStatePropertyAll<Color>(Colors.blue);
  var color = MaterialStatePropertyAll<Color>(Colors.grey[900]!);
  var msg = " ";
  if(val == 2){
    color = red;
    msg = "X";
  } else if(val == 1){
      color = blue;
      msg = "O";
  }
  return SizedBox(
    height: 150,
    width:  150,
    child: Padding(
        padding: const EdgeInsets.all(10),
        child:ElevatedButton(
        style: ButtonStyle(
          backgroundColor: color,
        ),
        onPressed: () => onTap(pos), 
          child: Align(
            alignment: Alignment.center,
            child: Text(
              msg,
              style: const TextStyle(fontSize: 90, color: Colors.white),
        ))))
      );
}
Widget _buildPointsTable(List<String> players){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child:Column(
          children: [
            displayTex(players[0]),
            displayTex("O")
          ])),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child:Column(
          children: [
            displayTex(players[1]),
            displayTex("X")
        ])),
    ]
  );
}
Widget tileRow(List<int> grid, List<int> vals, Function func){
  return Column(
    children: [
      tile(grid, vals[0],func),
      tile(grid, vals[1],func),
      tile(grid, vals[2],func),
    ],
  );
}
Widget grid(List<int> grid,Function func){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
             tileRow(grid,[0,3,6],func),
             tileRow(grid,[1,4,7],func),
             tileRow(grid,[2,5,8],func),
            ]
            )
    )
    ]);
}