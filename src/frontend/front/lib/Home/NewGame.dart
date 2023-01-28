// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, must_be_immutable, camel_case_types, no_logic_in_create_state, library_private_types_in_public_api, use_build_context_synchronously
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:front/Shared/Data.dart';
import 'package:http/http.dart' as http;

class NewGameScreen extends StatefulWidget {
  NewGameScreen(this.isMobile,this.playerNames, this.glob,{super.key});
  bool isMobile;
  Data glob;
  List<String> playerNames;
  @override
  _NewGameScreen createState() => _NewGameScreen(isMobile,playerNames,glob);
}

class _NewGameScreen extends State<NewGameScreen> { 
  _NewGameScreen(this.isMobile, this.playerNames, this.glob);
  double width = 0;
  bool isMobile;
  Data glob;
  List<String> playerNames;
  double fontSize = 0;

  @override
  Widget build(BuildContext context) {
    if(isMobile){
    width = 370;
    fontSize = 25;
  } else {
    fontSize = 35;
    width = 969;
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
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/plus.png",
                width: 80,
                height: 140,),
                const Text(
                  "Create new Game", 
                  style: TextStyle(color: Colors.white, fontSize: 35)
                ),
              ])
            ),
            
      ]),
      onPressed: () => {
        showModalBottomSheet(
          context: context, 
          builder: (_) => newMenu(isMobile,playerNames,fontSize,glob)
        )
      }));
  }
}

class newMenu extends StatefulWidget {
  newMenu(this.isMobile,this.playerNames, this.fontSize, this.glob, {super.key});
  bool isMobile;
  Data glob;
  List<String> playerNames;
  double fontSize;
  @override
  _newMenu createState() => _newMenu(isMobile,fontSize,glob, playerNames);
}

class _newMenu extends State<newMenu> {
  _newMenu( this.isMobile,this.fontSize, this.glob, this.playerNames);
  bool isMobile;
  double fontSize;
  Data glob;
  List<String> playerNames;
  List<String> Fields = ["New","Player1","TicTacToe",""];
  @override
  Widget build(BuildContext context) {
    void change(int val, String newVal){
      setState(() {
        Fields[val] = newVal;
      });
    }
    return SizedBox(
      height: 250,
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 32, 7, 61)),
        child : CreateGameMenu(isMobile, fontSize,Fields,change,context,glob.user,playerNames))
      );
  }
}

Widget CreateGameMenu(bool mobile, double fontSize, List<String> fields, Function func, BuildContext context, String user, List<String> playerNames){
  if(mobile){
    return Column( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: newGameSel(fields,fontSize ,true,func,playerNames),
        ),
        createButton(fontSize,200,50,context,fields, user)
    ]);
  } else{
    List<Widget> widgets = List.from(newGameSel(fields,fontSize ,false,func,playerNames),growable: true);
    widgets.add(createButton(fontSize ,300,140,context,fields, user));
    return Row( 
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }
}

Widget createButton(double fontSize, double width, double height, BuildContext context,List<String> fields, String user){
  return InkWell(
    onTap: () {
      createNewGame(fields,user,context);
    },
    // ignore: prefer_const_constructors
    child: Container(
      width: width,
      height: height,
      color: const Color.fromARGB(255, 7, 212, 134),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            'Create Game',
            style: TextStyle(color: Colors.white, fontSize: fontSize),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
}

void GameCreation(BuildContext context,bool suc) {
  if(!suc){
    ElegantNotification.error(
        width: 360,
        notificationPosition: NotificationPosition.topRight,
        animation: AnimationType.fromRight,
        title: const Text('Error'),
        description: const Text('Game was not made'),
        onDismiss: () {},
      ).show(context);
  } else {
    ElegantNotification.success(
        width: 360,
        notificationPosition: NotificationPosition.topRight,
        animation: AnimationType.fromRight,
        title: const Text('Success'),
        description: const Text('Game made was Created'),
        onDismiss: () {},
      ).show(context);
  }
}

List<Widget> newGameSel(List<String> fields, double fontSize,bool mobile, Function func, List<String> playerNames){
  if(mobile){
    return  [
        makePlayerSelect("Player    ", fields, playerNames, fontSize,mobile,0,func),
        makeSelect("Player Number     ", fields, ["Player1", "Player2"], fontSize,mobile,1,func),
        makeSelect("Gamemode    ", fields, ["TicTacToe", "Connect4"], fontSize,mobile,2,func)
      ];
} else{
    return  [
      makePlayerSelect("Player ", fields, playerNames, fontSize,mobile,0,func),
      makeSelect("Player Number", fields, ["Player1", "Player2"], fontSize,mobile,1,func),
      makeSelect("Gamemode", fields, ["TicTacToe", "Connect4"], fontSize,mobile,2,func)
    ];
}
}

Widget makePlayerSelect(String title, List<String> fields, List<String> options, double fontSize, bool mobile, int val, Function func){
    if(mobile){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text(title, style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: fontSize)),
            makePlayerSelHelper(fields, options, fontSize,val,func,mobile),
          ]
        );
  } else{
    return SizedBox(
      width: 300,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle( color: const Color.fromARGB(255, 16, 184, 226),fontSize: fontSize, fontWeight: FontWeight.w700)),
          makePlayerSelHelper(fields, options, fontSize,val,func,mobile),
        ]
      ));
  }
}

Widget makeSelect(String title, List<String> fields, List<String> options, double fontSize, bool mobile, int val, Function func){
  if(mobile){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle(color: const Color.fromARGB(255, 16, 142, 226), fontSize: fontSize)),
          makeSelectHelper(fields, options, fontSize,val,func,mobile),
        ]
      );
  } else{
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text(title, style: TextStyle( color: const Color.fromARGB(255, 16, 184, 226),fontSize: fontSize, fontWeight: FontWeight.w700)),
            makeSelectHelper(fields, options, fontSize,val,func,mobile),
          ]
        ));
  }
}

Widget makeSelectHelper(List<String> fields, List<String> options, double font, int val, Function func, bool isMobile){
  String init = fields[val];
  double padding = 15; 
  if(isMobile){
    padding = 5;
  } 
  return DecoratedBox(
  decoration: BoxDecoration( 
     color:const Color.fromARGB(255, 30, 51, 61), //background color of dropdown button
     border: Border.all(color: Colors.black38, width:3), //border of dropdown button
     borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
     boxShadow: const [ //apply shadow on Dropdown button
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                blurRadius: 5) //blur radius of shadow
          ]
  ),
  child:Padding(
    padding: EdgeInsets.all(padding),
    child:DropdownButton(
    style: TextStyle(color: const Color.fromARGB(255, 16, 142, 226), fontSize: font),
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
    iconEnabledColor: Colors.white,
    dropdownColor: const Color.fromARGB(255, 30, 51, 61),
    underline: Container(), 
    )
  ));
}

Widget makePlayerSelHelper(List<String> fields, List<String> options, double font, int val, Function func, bool isMobile){
  String init = fields[val];
  String player = "";
  TextEditingController mycontroller = TextEditingController();
  List<String> playerNames = options.map((e) => e).toList();
  playerNames.remove("All");
  if(!playerNames.contains("New")){
    playerNames.add("New");
  }
  double padding = 15; 
  if(isMobile){
    padding = 5;
  } 
  Widget wid = DecoratedBox(
  decoration: BoxDecoration( 
     color:Color.fromARGB(255, 30, 51, 61), //background color of dropdown button
     border: Border.all(color: Colors.black38, width:3), //border of dropdown button
     borderRadius: BorderRadius.circular(10), //border raiuds of dropdown button
     boxShadow: const [ //apply shadow on Dropdown button
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                blurRadius: 5) //blur radius of shadow
          ]
  ),
  child:Padding(
    padding: EdgeInsets.all(padding),
    child:DropdownButton(
    style: TextStyle(color: const Color.fromARGB(255, 16, 142, 226), fontSize: font),
    alignment: Alignment.center,
    value: init,
    items: playerNames.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    onChanged: (String? newValue) {
        init = newValue!;
        func(val, newValue);
    }, 
    iconEnabledColor: Colors.white,
    dropdownColor: const Color.fromARGB(255, 30, 51, 61), 
    underline: Container(), 
    )
  ));
  List<Widget> wigs= [
    wid,
    SizedBox(
      width: 200, 
      height: 80, 
      child: 
          TextField(
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.white, fontSize: 23),
          labelStyle: TextStyle(color:Colors.white, fontSize: 23),
          border: OutlineInputBorder(),
          labelText:'User Name',
          hintText:'Enter Your Name',
          ),
          onChanged: (String? me) => {
            func(3, me)
            } )),
    ];
  if(init == "New"){
    if(isMobile){
      return Row(
        children: wigs,
      );
    } else {
      return Column(
        children: wigs,
      );
    }
      
  } else {
    return wid;
  }
}

void createNewGame(List<String> data, String user, BuildContext context){
  int pos = data[1] == "Player1" ? 1 : 2;
  int gamemode = data[2] == "TicTacToe" ? 1 : 2;
  if(data[0] == "New"){
    createNewGameHelper(data[3], user, pos, gamemode, context);
  } else {
    createNewGameHelper(data[0], user, pos, gamemode, context);
  }

}

void createNewGameHelper(String Opponent, String user,int pos, int type, BuildContext context) async{
  var URL = "http://139.162.210.205/GameSev/Game/Create?type=$type&players=";
  if(pos == 1){
    URL += "$user, $Opponent"; 
  } else {
    URL += "$Opponent, $user"; 
  }
  try{
      final response = await http
    .get(Uri.parse(URL));
      if(response.statusCode == 200){
        if(response.body == "Game has been added"){
          GameCreation(context, true);
        }
      } else {
      GameCreation(context, false);
      }
    } on Exception{
      GameCreation(context, false);
    }
}