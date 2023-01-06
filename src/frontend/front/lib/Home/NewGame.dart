// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

Widget newGame(MediaQueryData data, BuildContext context, List<String> playerNames) {
  double width;
  String Opp = "Opp";
  String Gamemode = "TicTacToe";
  String Player = "Player1";
  double fontSize;
  if(data.size.width < data.size.height){
    width = 370;
    fontSize = 20;
  } else {
    fontSize = 35;
    width = 900;
  }
  return Padding(
    padding: const EdgeInsets.fromLTRB(0,10,0,5),
    child:ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blueGrey),
      ),
      child:  Row(
        children: [
          SizedBox(
            width:  width,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/plus.png",
                width: 100,
                height: 150,),
                const Text(
                  "Create new Game", 
                  style: TextStyle(color: Colors.white, fontSize: 20)
                )
              ])
            ),
      ]),
      onPressed: () => {
        showModalBottomSheet(
          context: context, 
          builder: (BuildContext context){
            return SizedBox(
              height: 200,
              child: Container(
                decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 179, 146)),
                child : CreateGameMenu(data.size.width < data.size.height, fontSize, Opp, Player, Gamemode))
              );
          })
      },
  ));
}

Widget CreateGameMenu(bool mobile, double fontSize, String Opp, String Player, String Gamemode){
  if(mobile){
    return Column( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: newGameSel(Opp,Player,Gamemode,fontSize,true),
        ),
        createButton(fontSize  ,300,30)
    ]);
  } else{
    List<Widget> widgets = List.from(newGameSel(Opp,Player,Gamemode,fontSize - 5,false),growable: true);
    widgets.add(createButton(fontSize - 5,300,100));
    return Row( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,

    );
  }
}

Widget createButton(double fontSize, double width, double height){
  return SizedBox(
    width: width,
    height: height,
    child: ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.greenAccent)
      ),
      onPressed: (){},
      child: Container(
        decoration: const BoxDecoration(),
        child: Text("Create", style: TextStyle(fontSize: fontSize)),
      )));
}

List<Widget> newGameSel(String Opp, String Player, String Gamemode, double fontSize,bool mobile){
  if(mobile){
    return  [
        makeSelect("Player    ", Opp, ["Opp", ], fontSize,mobile),
        makeSelect("Player Number     ", Player, ["Player1", "Player2"], fontSize,mobile),
        makeSelect("Gamemode    ", Gamemode, ["TicTacToe", "Connect4"], fontSize,mobile)
      ];
} else{
    return  [
      Padding(padding: const EdgeInsets.all(30),child: makeSelect("Player ", Opp, ["Opp", ], fontSize,mobile)),
      Padding(padding: const EdgeInsets.all(40),child: makeSelect("Player Number", Player, ["Player1", "Player2"], fontSize,mobile)),
      Padding(padding: const EdgeInsets.all(30),child: makeSelect("Gamemode", Gamemode, ["TicTacToe", "Connect4"], fontSize,mobile))
    ];
}
}

Widget makeSelect(String title, String intial, List<String> options, double fontSize, bool mobile){
  if(mobile){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: fontSize)),
          makeSelectHelper(intial, options, fontSize),
        ]
      );
  } else{
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle( color: const Color.fromARGB(255, 17, 65, 97),fontSize: fontSize)),
          makeSelectHelper(intial, options, fontSize),
        ]
      );
  }
}

Widget makeSelectHelper(String intial, List<String> options, double font){
  return DropdownButton(
    
    style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: font),
    alignment: Alignment.center,
    value: intial,
    items: options.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (String? newValue) {
        intial = newValue!;
    },
  ) ;
}