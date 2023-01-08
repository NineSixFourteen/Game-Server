// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:front/Shared/Common.dart';
import 'package:front/TicTac/TicBoard.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchGame() async {
  return await http.get(Uri.parse('http:localhost/Game/get'));
}

// ignore: must_be_immutable, prefer_typing_uninitialized_variables
class TicToeGame extends StatefulWidget {
  TicToeGame({super.key,required this.id,required this.auth, required this.socket});
  int id;
  String auth;
  WebSocketChannel socket;

  @override
  // ignore: no_logic_in_create_state
  State<TicToeGame> createState() => _TicToeGame(id, [],0,true,"1, 2", auth,0,false,socket);
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
  WebSocketChannel socket;
  // ignore: type_init_formals
  _TicToeGame(this.id, this.board,this.playerNum,this.turn,this.players,this.auth,this.winner,this.gameDone,this.socket){
    board = [0,0,0,0,0,0,0,0,0,0,0];
    winner = -1;
    gameDone = false;
    updateBB();
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
    socket.sink.add(getMessage(move));
  }

  void updateBB() async{
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
  
  @override
  Widget build(BuildContext context) {
    MediaQueryData data = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        automaticallyImplyLeading: false,
        leading: 
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed:(){
             socket.sink.close();
             Navigator.pop(context);
            }
          ),
        title: const Align(
          alignment: Alignment.center,
          child:Text('Tic Tac Toe',textAlign: TextAlign.center,) 
          )
      ),
      backgroundColor: Colors.black45,
      body: Column(
          children: [
            _buildPointsTable(players.split(", ")),
            grid(board,update,data)
          ]
          ),
    );
  }
  
  getMessage(int move) {
    return "$id,$move,$auth";
  }
  
  List<int> toBoard(String msg) {
    List<int> board = List.from(msg.codeUnits);
    for(int i = 0; i < board.length;i++){
      board[i] = board[i] - 48;
    }
    return board;
  }
}

Widget tile(List<int> board, int pos, Function onTap, bool mob){
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
  double size;
  if(mob){
    size = 120;
  } else {
    size = 150;
  }
  return SizedBox(
    height: size,
    width:  size,
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
            displayText(players[0]),
            displayText("O")
          ])),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child:Column(
          children: [
            displayText(players[1]),
            displayText("X")
        ])),
    ]
  );
}

Widget tileRow(List<int> grid, List<int> vals, Function func,bool mobile){
  return Column(
    children: [
      tile(grid, vals[0],func,mobile),
      tile(grid, vals[1],func,mobile),
      tile(grid, vals[2],func,mobile),
    ],
  );
}

Widget grid(List<int> grid,Function func, MediaQueryData data){
  bool mobile = data.size.width < data.size.height ; 
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
             tileRow(grid,[0,3,6],func,mobile),
             tileRow(grid,[1,4,7],func,mobile),
             tileRow(grid,[2,5,8],func,mobile),
            ]))
    ]);
}