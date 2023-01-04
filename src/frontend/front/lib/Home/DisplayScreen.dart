// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, empty_catches, must_be_immutable, no_logic_in_create_state, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:front/TicTac/TicTacGui.dart';
import 'package:http/http.dart' as http;
import '../TicTac/TicBoard.dart';
import 'package:front/Home/DisplayHelper.dart';

class DisplayScreen extends StatelessWidget {
  DisplayScreen(this.data, {super.key});
  Data data;

  @override
  Widget build(BuildContext context) {
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
      body: 
          Stack(
            children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.fill
                ))
          ),
          SingleChildScrollView(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CardC(
                    StatsHeading(defaultHead(),data),
                    StatsBody(data),
                    data,backG(Colors.black)
                  ),
                  filter(data),
                  Column(
                    children: boards.map(
                      (board) => DisplayGame(board, glob,data,context)
                      ).toList(),
                  ),
                  ElevatedButton(onPressed: ()=> KK(), child: const Text("Press ME"))])]
    ))]));
  }


  void KK() async {
    //Fake Data for testing 
    fakeGames();
    /* 
    try{
      final response = await http
        .get(Uri.parse('http://localhost:5083/Games?name=$name&auth=$auth'));
        if(response.statusCode == 200){
          if(response.body != "Error: User not found") {
            List<String> l = response.body.substring(1, response.body.length - 1).split(",");
            List<int> nums = l.map((e) => int.parse(e)).toList();
            getGames(nums);
          }
        } 
    } on Exception{
      print("fail2");
    }
    */
  }
  void fakeGames() {
    List<Board> boar = List.empty(growable: true);
    boar.add(
      const Board(players: ["Test1","player1"], board: [0,0,0,1,2,1,0,2,0], turn: 0, winner: -1, gameDone: true, photos: [0,2], id: 0)
    );
    boar.add((
      const Board( id: 4,players: ["Stranger","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 1, winner: -1, gameDone: true,photos: [1,2]))
    );
        boar.add((
      const Board( id: 4,players: ["ssssda","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 1, winner: -1, gameDone: false,photos:[4,2]))
    );
        boar.add((
      const Board( id: 4,players: ["dsad","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 2, winner: -1, gameDone: false  ,photos: [3,2]))
    );
        boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 1, winner: 1, gameDone: true,photos: [0,2]))
    );
    for(Board bor in boar){
      setState(() {
        boards.add(bor);
      });
    }
  }
  void getGames(List<int> games) async {
    for(int n in games){
      try{
        final response = await http
          .get(Uri.parse('http://localhost:5083/Game/Get?id=$n'));
          if(response.statusCode == 200){
            if(response.body != "Error: User not found" && !added.contains(n)) {
              added.add(n);
              setState(()  {
                boards.add(Board.fromJson(jsonDecode(response.body),n));
              });
            }
          } 
      } on Exception{
        print("fail");
      }
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

Widget filter(MediaQueryData data) {
  if(data.size.width < data.size.height){

  } else {

  }
  return Text("s");
}

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
    if(board.winner == 1){
      color = Color.fromARGB(255, 18, 204, 27);
      text = Text( "Victory",style: TextStyle(color: Colors.black, fontSize: fontSize));
    } else {
      text = Text( "Defeat",style: TextStyle(color: Colors.black, fontSize: fontSize));
      color = Color.fromARGB(255, 223, 11, 11);
    }
  } else {
    if(board.turn == emm){
      text = Text( "Your Turn",style: TextStyle(color: const Color.fromARGB(255, 15, 2, 44), fontSize: fontSize));
    } else {
     text = Text( "Opponent Turn",style: TextStyle(color: const Color.fromARGB(255, 134, 8, 8), fontSize: fontSize));
    }
    color = Color.fromARGB(255, 19, 187, 230);
  }
  TextStyle sty = TextStyle(
    color: Colors.white,
    fontSize: data.size.height/20
  );
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
      onPressed: () => {loadGame(board.id, context,glob.auth)},
  ));
}


  void loadGame(int gameID, BuildContext context, String auth){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TicToeGame(id:gameID, auth:auth)),
      );
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



