// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, empty_catches, must_be_immutable, no_logic_in_create_state, unrelated_type_equality_checks, avoid_function_literals_in_foreach_calls

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:http/http.dart' as http;
import '../TicTac/TicBoard.dart';
import 'package:front/Shared/TextSelc.dart';
import 'package:front/Home/Stats.dart';
import 'package:front/Home/GameDisplays.dart';
import 'package:front/Home/Filter.dart';
import 'package:front/Home/NewGame.dart';

class DisplayScreen extends StatelessWidget {
  DisplayScreen(this.data, this.isMobile,{super.key});
  Data data;
  bool isMobile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Display(isMobile: isMobile ,glob: data),
    );
  }
}

class Display extends StatefulWidget {
  Display({super.key, required this.isMobile,required this.glob});
  bool isMobile;
  Data glob;
  @override
  State<StatefulWidget> createState() => _Display(isMobile,glob,"","");
}

class _Display extends State<Display> {
  _Display(this.isMobile, this.glob,this.name,this.auth){
    name = glob.user;
    auth = glob.auth;
    KK();
  }

  String name;
  String auth;
  bool isMobile;
  Data glob;

  List<Board> boards = List.empty(growable: true);
  List<Board> filteredBoards = List.empty(growable: true);
  List<Board> displayBoards = List.empty(growable: true);

  List<String> playerNames = List.empty(growable: true);

  var filters = [
    "All",
    "All",
    "All",
  ];

  var navInfo = [
    0,
    3
  ];

  void changeNav(int val, String newVal){
    setState(() {
      navInfo[val] = int.parse(newVal);
    });
    updateDisplayBoards();
  }

  void changeFilters(int val, String newVal){
    setState(() {
      filters[val] = newVal;
    });
    filterBoards(filters[0],filters[1],filters[2]);
    updateDisplayBoards();
  }

  List<int> added = List.empty(growable: true);
  final field1 = TextEditingController();
  final field2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(!playerNames.contains("All")){
      playerNames.add("All");
    }
    playerNames.remove(glob.user);
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
          SingleChildScrollView(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CardC(
                    StatsHeading(defaultHead(),isMobile),
                    StatsBody(isMobile, anaylseGames()),
                    isMobile,backG(Colors.black)
                  ),
                  filter(isMobile,filters,changeFilters,playerNames),
                  ControllBoard(navInfo,isMobile,changeNav, (boards.length/navInfo[1]).ceil(),KK ),
                  NewGameScreen(isMobile,playerNames,glob),
                  Column(
                    children: GamesDis(displayBoards,glob,isMobile, context),
                  )])]
    ))]));
  }

  void filterBoards(String player, String result, String gamemode){
    setState(() {
      filteredBoards = List.empty(growable: true);
    });
    for(Board bo in boards){
      if(player != "All" ){
        if(!bo.players.contains(player)){
          continue;
        }
      }
      if(result != "All"){
        String res = findResult(bo);
        if(res != result){
          continue;
        }
      }
      if(gamemode != "All"){
        if(gamemode == "TicTacToe" && bo.board.length != 9){ // 9 tiles
          continue;
        } else if(gamemode == "Connect4" && bo.board.length != 49){ // 49 tiles
          continue;
        }
      }
      setState(() {
        filteredBoards.add(bo);
      });
    }
  }

  void KK() async {
    if(mounted){
      setState(() {
        displayBoards = List.empty(growable: true);
        boards = List.empty(growable: true);
      });
      try{
        final response = await http
          .get(Uri.parse('http://139.162.210.205/GameSev/Games?name=$name&auth=$auth'));
          if(response.statusCode == 200){
            if(response.body != "Error: User not found") {
              String l = response.body.substring(1, response.body.length - 1);
              getGames(l);
              filterBoards(filters[0],filters[1],filters[2]);
              updateDisplayBoards();
            }
        }
      } catch (Exception){
        print(Exception);
      }
    } else {
      await Future.delayed(Duration(seconds: 5)); 
      KK();
    }
  }
  void getGames(String games) async {
      try{
        List<int> nums = games.split(",").map((e) => int.parse(e)).toList();
        int n = 0;
        Board b;
        final response = await http
          .get(Uri.parse('http://139.162.210.205/GameSev/Game/Gets/$games'));
          if(response.statusCode == 200){
            if(response.body != "Error: User not found") {
              (json.decode(response.body) as List)
                .forEach(
                  (i) => {
                    b = Board.fromJson(i,nums[n++]),
                    for(String name in b.players){
                      if(!playerNames.contains(name)){
                        playerNames.add(name)
                      }
                    },
                    boards.add(b),
                  });
              setState(() {});
            }
          } 
      } on Exception{
      }
    
  }
  
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    field1.dispose();
    field2.dispose();
    super.dispose();
  }  

  List<List<int>> anaylseGames() {
    List<List<int>> ret = List.empty(growable: true);
    for(int i =0 ; i < 6; i++){
      ret.add(List.filled(3,0, growable: true));
    }
    for(Board bo in boards){
      int num = getPlayer(bo);
      if(bo.board.length == 9){ // If TicTacToe
        ret[0][1]++; 
        if(bo.gameDone){ // If TicTacToeGame is Done
          if(bo.winner == num){ // If win
            ret[2][1]++; 
          } else if(bo.winner == -1){ //If draws
            ret[3][1]++;
          } else { // if Lose
            ret[4][1]++;
          }
        }else { // If TicTacToeGame is in progress
          ret[5][1]++;
        }
      } else{ // If Connect4
        ret[0][2]++;
        if(bo.gameDone){ // If Connect4 is Done
            if(bo.winner == num){ // If win
            ret[2][2]++; 
          } else if(bo.winner == -1){ //If draws
            ret[3][2]++;
          } else { // if Lose
            ret[4][2]++;
        } 
        } else { // If Connect4 is in progress
          ret[5][2]++;
        }
      }
    }
    ret[0][0] = ret[0][1] + ret[0][2]; // Total games played = tic games + con games
    ret[2][0] = ret[2][1] + ret[2][2]; // Total of games won = tic wins + con wins
    ret[3][0] = ret[3][1] + ret[3][2]; // Total of games loss 
    ret[4][0] = ret[4][1] + ret[4][2]; // Total of games draw 
    ret[5][0] = ret[5][1] + ret[5][0]; // Total of game incomplete
    ret[1][0] = (ret[2][0] * 100 / (ret[0][0] - ret[5][0] == 0 ? 1 : ret[0][0] - ret[5][0])).round() ; // Win rate = games won *100 / total games
    ret[1][1] = (ret[2][1] * 100 / (ret[0][1] - ret[5][1] == 0 ? 1 : ret[0][1] - ret[5][1])).round() ;
    ret[1][2] = (ret[2][2] * 100 / (ret[0][2] - ret[5][2] == 0 ? 1 : ret[0][2] - ret[5][2])).round() ;
    return ret ;
  }
  
  int getPlayer(Board bo) {
    if(bo.players[0] == name){
      return 1;
    } else{
      return 2;
    }
  }
  
  String findResult(Board bo) {
    if(bo.gameDone){
      if(bo.winner == -1){
        return "Draw";
      }
      int player = getPlayer(bo);
      if(bo.winner == player){
        return "Win";
      } else {
        return "Lose";
      }
    } else {
      return "Incomplete";
    }
  }
  
  void updateDisplayBoards() {
    displayBoards = List.empty(growable: true);
    for(int i = navInfo[0] * navInfo[1];i < navInfo[0] * navInfo[1] + navInfo[1];i++){
      setState(() {
        if(filteredBoards.length > i){
          displayBoards.add(filteredBoards[i]);
        }
      });}setState(() {
        
      });
      
  }
  
}

List<Widget> GamesDis(List<Board> displayBoards, Data glob, bool isMobile,BuildContext context) {
  List<Widget> wiges = List.empty(growable: true);
  List<Widget> temp = List.empty(growable: true);
  for(int i =0; i < displayBoards.length;){
    List<Widget> temp = List.empty(growable: true);
    for(int l = 0; l < 3;l++){
      if(i < displayBoards.length){
        temp.add(DisplayGame(displayBoards[i++],glob,isMobile,context));
      }
    }
    wiges.add(Row(children: temp));
  }
  return wiges;
}

Widget ControllBoard(List<int> navInfo, bool mobile, Function change, int pages, Function KK){
  double width = 1000;
  double height = 140;
  if(mobile){
    width = 400;
    height = 150;
  }
  return Padding(
    padding: const EdgeInsets.fromLTRB(0,4,0,0),
    child: SizedBox(
    width: width,
    height: height,
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(height: height/20,),
          SizedBox(
            width: width - 8,
            height: height * 0.25,
            child: Container(
                decoration: BoxDecoration(color: Colors.black,boxShadow: [BoxShadow(
                  color: Colors.grey[850]!,
                  offset: const Offset(0,0),
                  blurRadius: 1.0,
                  spreadRadius: 1.0)]),
                child: const Text("Navigation", style: TextStyle(fontSize: 25, color: Colors.greenAccent),textAlign: TextAlign.center)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height *0.7,
                width: width/3,
                child: TextSec("Show    ",["3","6","9","12","15","18","21"], mobile, 25, change, 1, dumbFunc(navInfo)),
              ),
              SizedBox(
                height: height*0.7,
                width: width/3,
                child: TextSec("Page    ",makeList(pages), mobile, 25, change, 0, dumbFunc(navInfo)),
              ),
              SizedBox(
                width: width/3,
                height: height *0.7 / 1.5,
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.blueGrey[500]),),
                    onPressed: () { KK();},
                    child: 
                      // ignore: prefer_const_literals_to_create_immutables
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                      // ignore: prefer_const_constructors
                      Icon(
                        Icons.refresh_sharp,
                        color: Colors.white,
                        size: 25.0,
                        ),
                        Text("Refresh", style: TextStyle(color: Colors.white, fontSize: 20),)
                      ],
                    ),
                  ),
          ))],
          )
      ]))
  ));
}

List<String> makeList(int pages) {
  List<String> ret = List.empty(growable: true);
  if(pages ==0){
    ret.add("0");
    return ret;
  }
  for(int i = 0; i < pages;i++){
    ret.add("$i");
  }
  return ret;
}

List<String> dumbFunc(List<int> nums){
  return nums.map((e) => "$e").toList();
}