// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, must_be_immutable, camel_case_types, no_logic_in_create_state, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';


Widget CreateGameMenu(bool mobile, double fontSize, List<String> fields, Function func){
  if(mobile){
    return Column( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: newGameSel(fields,fontSize,true,func),
        ),
        createButton(fontSize,300,30)
    ]);
  } else{
    List<Widget> widgets = List.from(newGameSel(fields,fontSize - 5,false,func),growable: true);
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

List<Widget> newGameSel(List<String> fields, double fontSize,bool mobile, Function func){
  if(mobile){
    return  [
        makeSelect("Player    ", fields, ["Opp", ], fontSize,mobile,0,func),
        makeSelect("Player Number     ", fields, ["Player1", "Player2"], fontSize,mobile,1,func),
        makeSelect("Gamemode    ", fields, ["TicTacToe", "Connect4"], fontSize,mobile,2,func)
      ];
} else{
    return  [
      Padding(padding: const EdgeInsets.all(30),child: makeSelect("Player ", fields, ["Opp", ], fontSize,mobile,0,func)),
      Padding(padding: const EdgeInsets.all(40),child: makeSelect("Player Number", fields, ["Player1", "Player2"], fontSize,mobile,1,func)),
      Padding(padding: const EdgeInsets.all(30),child: makeSelect("Gamemode", fields, ["TicTacToe", "Connect4"], fontSize,mobile,2,func))
    ];
}
}

Widget makeSelect(String title, List<String> fields, List<String> options, double fontSize, bool mobile, int val, Function func){
  if(mobile){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: fontSize)),
          makeSelectHelper(fields, options, fontSize,val,func),
        ]
      );
  } else{
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle( color: const Color.fromARGB(255, 17, 65, 97),fontSize: fontSize)),
          makeSelectHelper(fields, options, fontSize,val,func),
        ]
      );
  }
}

Widget makeSelectHelper(List<String> fields, List<String> options, double font, int val, Function func ){
  String init = fields[val];
  return DropdownButton(
    dropdownColor: const Color.fromARGB(255, 50, 179, 146),
    style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: font),
    alignment: Alignment.center,
    value: init,
    items: options.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (String? newValue) {
        init = newValue!;
        func(val, newValue);
    },
  ) ;
}

class NewGameScreen extends StatefulWidget {
  NewGameScreen(this.data,this.playerNames, {super.key});
  MediaQueryData data;
  List<String> playerNames;
  @override
  _NewGameScreen createState() => _NewGameScreen(data,playerNames);
}

class _NewGameScreen extends State<NewGameScreen> { 
  _NewGameScreen(this.data, this.playerNames);
  double width = 0;
  MediaQueryData data;
  List<String> playerNames;
  double fontSize = 0;

  @override
  Widget build(BuildContext context) {
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
          builder: (_) => newMenu(data,playerNames,fontSize)
        )
      }));
  }
}

class newMenu extends StatefulWidget {
  newMenu(this.data,this.playerNames, this.fontSize, {super.key});
  MediaQueryData data;
  List<String> playerNames;
  double fontSize;
  @override
  _newMenu createState() => _newMenu(data,fontSize);
}

class _newMenu extends State<newMenu> {
  _newMenu( this.data,this.fontSize);
  MediaQueryData data;
  double fontSize;
  List<String> Fields = ["Opp","Player1","TicTacToe"];
  @override
  Widget build(BuildContext context) {
    void change(int val, String newVal){
      setState(() {
        Fields[val] = newVal;
      });
    }
    return SizedBox(
      height: 200,
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 179, 146)),
        child : CreateGameMenu(data.size.width < data.size.height, fontSize,Fields,change))
      );
  }
}