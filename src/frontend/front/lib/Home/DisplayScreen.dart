// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, empty_catches

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/Shared/Common.dart';
import 'package:front/Shared/Data.dart';
import 'package:http/http.dart' as http;

import '../TicTac/TicBoard.dart';

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

// ignore: must_be_immutable
class Display extends StatefulWidget {
  Display({super.key, required this.data,required this.glob});
  MediaQueryData data;
  Data glob;
  @override
  // ignore: no_logic_in_create_state
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

  @override
  Widget build(BuildContext context) {
    String name = glob.user;
    // ignore: prefer_const_constructors
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
                    Card(
                      child: 
                      Container(  
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          // ignore: prefer_const_literals_to_create_immutables
                          boxShadow: [const BoxShadow(
                            color: Colors.black,
                            offset: Offset(0.0,.0,),
                            blurRadius: 4.0,
                            spreadRadius: 4.0
                          )]
                        ),
                        child: 
                          SizedBox(
                            width: data.size.width/2,
                            height: data.size.height/4,
                            child: Column(
                              children: [
                                  Row(
                                    children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                          child: Card(
                                            color: Colors.grey[800],
                                            elevation: 1,
                                            
                                            child: SizedBox(
                                              width: 620,
                                              height: 50,
                                              
                                              child: 
                                              Container(
                                                // ignore: prefer_const_constructors
                                                decoration: BoxDecoration(
                                                  boxShadow:  [
                                                    BoxShadow(
                                                      color: Colors.grey[850]!,
                                                      offset: const Offset(0,0),
                                                      blurRadius: 1.0,
                                                      spreadRadius: 1.0)
                                                  ]
                                                ),
                                                child:Text("Stats",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: data.size.height/25
                                                  )))),
                                      )),
                                    ],
                                  ),
                                  Row(
                                    children: const [
                                      Text("LALAL")
                                    ],
                                  )
                      ])))),
                    Column(
                      children: boards.map(
                        (word)=> DisplayGame(word,glob,data)
                        ).toList(),
                        ),
                    ElevatedButton(onPressed: ()=> KK(), child: const Text("Press ME"),)
              ])])]));
  } 
}

Widget DisplayGame(Board board, Data glob,MediaQueryData data ){
  String player = "";
  List<String> players = board.players;
  int emm = 0;
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

  return Padding(padding: const EdgeInsets.all(10),
            child:ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black),
              ),
              child: SizedBox(
                
                width: data.size.width/1.7,
                height: data.size.height/6,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text("Opponent: $player",
                          style: sty,
                          textAlign: TextAlign.left),
                        Text("Gamemode: Tic Tac Toe",
                          style: sty),
                      ]
                    ),
                    Column(
                      children: const [
                        Text("sdsad")
                      ],
                    )
                  ],
              )),
              onPressed: () => {},
        ));
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(-73,20);
    const p2 = Offset(400,20);
    final paint = Paint()
    ..color = Colors.grey[900]!
    ..strokeWidth = 4;
  canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}