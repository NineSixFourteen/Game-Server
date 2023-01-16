// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable, must_be_immutable, camel_case_types, no_logic_in_create_state, library_private_types_in_public_api, use_build_context_synchronously
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:front/Shared/Data.dart';
import 'package:http/http.dart' as http;

class NewGameScreen extends StatefulWidget {
  NewGameScreen(this.data,this.playerNames, this.glob,{super.key});
  MediaQueryData data;
  Data glob;
  List<String> playerNames;
  @override
  _NewGameScreen createState() => _NewGameScreen(data,playerNames,glob);
}

class _NewGameScreen extends State<NewGameScreen> { 
  _NewGameScreen(this.data, this.playerNames, this.glob);
  double width = 0;
  MediaQueryData data;
  Data glob;
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
                ),
              ])
            ),
            
      ]),
      onPressed: () => {
        showModalBottomSheet(
          context: context, 
          builder: (_) => newMenu(data,playerNames,fontSize,glob)
        )
      }));
  }
}

class newMenu extends StatefulWidget {
  newMenu(this.data,this.playerNames, this.fontSize, this.glob, {super.key});
  MediaQueryData data;
  Data glob;
  List<String> playerNames;
  double fontSize;
  @override
  _newMenu createState() => _newMenu(data,fontSize,glob, playerNames);
}

class _newMenu extends State<newMenu> {
  _newMenu( this.data,this.fontSize, this.glob, this.playerNames);
  MediaQueryData data;
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
      height: 200,
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 179, 146)),
        child : CreateGameMenu(data.size.width < data.size.height, fontSize,Fields,change,context,glob.user,playerNames))
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
            children: newGameSel(fields,fontSize,true,func,playerNames),
        ),
        createButton(fontSize,280,40,context,fields, user)
    ]);
  } else{
    List<Widget> widgets = List.from(newGameSel(fields,fontSize - 5,false,func,playerNames),growable: true);
    widgets.add(createButton(fontSize - 5,300,100,context,fields, user));
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
      Padding(padding: const EdgeInsets.all(40),child: makeSelect("Player Number", fields, ["Player1", "Player2"], fontSize,mobile,1,func)),
      Padding(padding: const EdgeInsets.all(30),child: makeSelect("Gamemode", fields, ["TicTacToe", "Connect4"], fontSize,mobile,2,func))
    ];
}
}

Widget makePlayerSelect(String title, List<String> fields, List<String> options, double fontSize, bool mobile, int val, Function func){
    if(mobile){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Text(title, style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: fontSize)),
            makePlayerSelHelper(fields, options, fontSize,val,func),
          ]
        );
  } else{
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Text(title, style: TextStyle( color: const Color.fromARGB(255, 17, 65, 97),fontSize: fontSize)),
          makePlayerSelHelper(fields, options, fontSize,val,func),
        ]
      );
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
  print(options);
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

Widget makePlayerSelHelper(List<String> fields, List<String> options, double font, int val, Function func ){
  String init = fields[val];
  String player = "";
  TextEditingController mycontroller = TextEditingController();
  List<String> playerNames = options.map((e) => e).toList();
  playerNames.remove("All");
  if(!playerNames.contains("New")){
    playerNames.add("New");
  }
  if(fields[0] == "New"){
    print(playerNames);
    print("Hell");
  }
  Widget wid = DropdownButton(
      dropdownColor: const Color.fromARGB(255, 50, 179, 146),
      style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: font),
      alignment: Alignment.center,
      value: init,
      items: playerNames.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
          func(val, newValue);
      },
    ) ;
  if(init == "New"){
    return  Column(
      children: [
        wid,
        SizedBox(
          width: 140, 
          height: 70, 
          child: 
              TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText:'User Name',
              hintText:'Enter Your Name',
              ),
              onChanged: (String? me) => {
                func(3, me)
                } )),
        ]);
            

  
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
  var URL = "http://localhost:5083/Game/Create?type=$type&players=";
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