// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, empty_catches, must_be_immutable, no_logic_in_create_state, unrelated_type_equality_checks

// ignore: todo
//TODO 
// Make A function that takes a List<List<int>> values , int height, int width, bool mobile
// Add produces a set of size boxes 
// Factor out card to a Heading and a Body 

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:http/http.dart' as http;
import '../TicTac/TicBoard.dart';
import 'package:front/Home/DisplayHelper.dart';

// ignore: must_be_immutable
class DisplayScreen extends StatelessWidget {
  DisplayScreen(this.data, {super.key});
  Data data;

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Display(data: queryData,glob: data),
    );
  }
}

class Display extends StatefulWidget {
  Display({super.key, required this.data,required this.glob});
  MediaQueryData data;
  Data glob;
  @override
  State<StatefulWidget> createState() => _Display(data,glob,"","");
}

class _Display extends State<Display> {
  _Display(this.data, this.glob,this.name,this.auth){
    KK();
    name = glob.user;
    auth = glob.auth;
  }
  String name;
  String auth;
  MediaQueryData data;
  Data glob;
  List<Board> boards = List.empty(growable: true);
  List<int> added = List.empty(growable: true);

  final field1 = TextEditingController();
  final field2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String name = glob.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Center(child: Text("Player: $name")),
      ),
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover
                ))
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CardC(
                    StatsHeading(defaultHead(),data),
                    StatsBody(data),
                    data,backG(Colors.black)
                  ),
                  Column(
                    children: boards.map(
                      (word)=> DisplayGame(word,glob,data)
                      ).toList(),
                  ),
                  ElevatedButton(onPressed: ()=> KK(), child: const Text("Press ME"))])]
    )]));
  }

  void KK() async{
    try{
      final response = await http
        .get(Uri.parse('http://localhost:5083/Games?name=$name&auth=$auth'));
        if(response.statusCode == 200){
          print(response.body);
          if(response.body != "Error: User not found") {
            List<String> l = response.body.substring(1, response.body.length - 1).split(",");
            List<int> nums = l.map((e) => int.parse(e)).toList();
            getGames(nums);
          }
        } 
    } on Exception{}
  }

  void getGames(List<int> games) async {
    for(int n in games){
      try{
        final response = await http
          .get(Uri.parse('http://localhost:5083/Game/Get?id=$n'));
          if(response.statusCode == 200){
            print(response.body);
            if(response.body != "Error: User not found" && !added.contains(n)) {
              added.add(n);
              setState(()  {
                boards.add(Board.fromJson(jsonDecode(response.body)));
              });
            }
          } 
      } on Exception{}
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    field1.dispose();
    field2.dispose();
    super.dispose();
  }
}

Widget DisplayGame(Board board, Data glob,MediaQueryData data ){
  String player = "";
  List<String> players = board.players;
  int emm = 0;
  int moves = getMoves(board.board);
  for(int i = 0; i < 2;i++){
    if(players[i] != glob.user){
      player = players[i];
      emm = i == 1 ? 0 : 1;
    }
  }
  TextStyle sty = TextStyle(
    color: Colors.white,
    fontSize: data.size.height/20
  );
  double width = data.size.width / 1.4;
  return Padding(
    padding: const EdgeInsets.fromLTRB(0,10,0,10),
    child:ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.black),
      ),
      child: Row(
        children: [
          SizedBox(
            width: width/7,
            height: 80,
            child: Image.asset("assets/images/temp.png")
            ),
          SizedBox(
            width: (width/5),
            height: 80,
            child: Column(
              children: [
                Row(children: [Text("  Vs $player",style: const TextStyle(color: Colors.red, fontSize: 33))]),
                Row(children: [Text("       Moves Made $moves",style: const TextStyle(color: Colors.red, fontSize: 18))])
            ])
            ),
          SizedBox(
            width: (width/5)*3 ,
            height: 80,
            child: Column(
              children: const [
                 Text( "Your Turn",style: TextStyle(color: Colors.red, fontSize: 50))
            ])
          ),
          SizedBox(
            width:  90,
            height: 75,
            child: Column(
              children: [
                ShowBoard(board.board)
            ])
            ),
    ]),
      onPressed: () => {},
  ));
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

Widget ShowBoard(List<int> board) {
  Widget wid;
  
  if(board.length == 9){
    print(board.length);
    wid = Row(
      children: [
        Column(
          children: [
            smallTile(board[0]),
            smallTile(board[3]),
            smallTile(board[6])
          ],
        ),
        Column(
          children: [
            smallTile(board[1]),
            smallTile(board[4]),
            smallTile(board[7])
          ],
        ),
        Column(
          children: [
            smallTile(board[2]),
            smallTile(board[5]),
            smallTile(board[8])
          ],
        )
      ],
    );
  } else{
    wid = Text("asdasdadasdasd", style: TextStyle(color: Colors.red),);
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

Widget smallTile(int val){
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
    height: 25,
    width:  30,
    child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: color,
        ),
        onPressed: () => {}, 
          child: Align(
            alignment: Alignment.center,
            child: Text(
              msg,
              style: const TextStyle(fontSize: 90, color: Colors.white),
        )))
      );
}

SizedBox Boxx(String head, List<int> vals, MediaQueryData data){
  int total = vals[0];
  int tic = vals[1];
  int row = vals[2];
  Column text;
 double width;
  double height;
  if(data.size.width < data.size.height){
    height = 96;
    width = data.size.width/2.22;
    text = Column(
      children: [
      Text(
          head,
          style: const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 21, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      Text(
      "Total: $total \n  TictacToe: $tic\n  Connect4: $row",
      style: const TextStyle(color: Colors.white, fontSize: 19),
      textAlign: TextAlign.center,
    )]);
  } else{
    height = 78;
    width = data.size.width/2.7;
    text = Column(
      children: [
        Text(
          head,
          style: const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 31, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          "Total: $total TictacToe: $tic Connect4: $row",
          style: const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 27, ),
          textAlign: TextAlign.center,
        )
      ]);
  } 
  return SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: text
        )
      );
}

StatsBody(MediaQueryData data) {
  return Row(
    children: [
      Column(
        children:  [
          Boxx("Games Played",[100,90,10],data),
          Boxx("Wins",[50,40,10], data),
          Boxx("Draws",[5,3,2], data)
        ],
      ),
      Column(
        children: [
          Boxx("Win Rate",[100,90,10],data ),
          Boxx("Losses",[50,40,10], data),
          Boxx("Incomplete",[5,3,2], data)
        ])]);
} 



