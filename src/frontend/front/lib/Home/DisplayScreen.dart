// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, empty_catches, must_be_immutable, no_logic_in_create_state, unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:http/http.dart' as http;
import '../TicTac/TicBoard.dart';
import 'package:front/Home/Stats.dart';
import 'package:front/Home/GameDisplays.dart';
import 'package:front/Home/Filter.dart';
import 'package:front/Home/NewGame.dart';

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
  List<Board> filteredBoards = List.empty(growable: true);
  List<Board> displayBoards = List.empty(growable: true);
  int start = 0;
  int amount = 8;
  List<String> playerNames = List.empty(growable: true);
  var filters = [
    "All",
    "All",
    "All",
  ];

  void changeFilters(int val, String newVal){
    setState(() {
      filters[val] = newVal;
    });
  }

  List<int> added = List.empty(growable: true);
  

  final field1 = TextEditingController();
  final field2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(!playerNames.contains("All")){
      playerNames.add("All");
    }
    KK();
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
          SingleChildScrollView(child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  CardC(
                    StatsHeading(defaultHead(),data),
                    StatsBody(data, anaylseGames()),
                    data,backG(Colors.black)
                  ),
                  filter(data,filters,changeFilters,playerNames),
                  newGame(data,context,playerNames),
                  Column(
                    children: displayBoards.map(
                      (board) => DisplayGame(board, glob,data,context)
                      ).toList(),
                  ),
                  ElevatedButton(onPressed: ()=> KK(), child: const Text("Press ME"))])]
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
    //Fake Data for testing 
    fakeGames();
    setState(() {
      displayBoards = List.empty(growable: true);
    });
    filterBoards(filters[0],filters[1],filters[2]);
    for(int i = start;i < start + amount;i++){
      setState(() {
        if(filteredBoards.length > i){
          displayBoards.add(filteredBoards[i]);
        }
      });
    }
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
      const Board(players: ["Test1","player1"], board: [0,0,0,1,2,1,0,2,0], turn: 0, winner: 2, gameDone: true, photos: [0,2], id: 0)
    );
    boar.add((
      const Board( id: 4,players: ["Stranger","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 1, winner: 1, gameDone: true,photos: [1,2]))
    );
    boar.add((
      const Board( id: 4,players: ["ssssda","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 1, winner: -1, gameDone: false,photos:[4,2]))
    );
    boar.add((
      const Board( id: 4,players: ["dsad","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 2, winner: -1, gameDone: false  ,photos: [3,2]))
    );
    boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,0,2,0], turn: 1, winner: 2, gameDone: true,photos: [0,2]))
    );
    boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 2, winner: 2, gameDone: true  ,photos: [3,2]))
    );
    boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,0,2,0], turn: 1, winner: -1, gameDone: true,photos: [3,2]))
    );
    boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,0,2,0], turn: 1, winner: 2, gameDone: true,photos: [3,2]))
    );
    boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,2,0], turn: 2, winner: 2, gameDone: true  ,photos: [3,2]))
    );
    boar.add((
      const Board( id: 4,players: ["Badger","Test1"], board: [2,1,2,1,2,1,1,0,2,0], turn: 1, winner: -1, gameDone: true,photos: [3,2]))
    );
    for(Board bor in boar){
      if(!boards.contains(bor)){
        for(String name in bor.players){
          if(!playerNames.contains(name)){
            playerNames.add(name);
          }
        }
        setState(() {
          boards.add(bor);
        });
      }
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
  
  createGame(String name, String opp, int gamemode) async {
    try{
        final response = await http
          .get(Uri.parse('http://localhost:5083/Game/Create?type=$gamemode&players=$name, $opp'));
          if(response.statusCode == 200){
            print(response.body);
          } 
      } on Exception{
        print("fail");
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
}






