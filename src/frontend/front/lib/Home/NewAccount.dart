//Todo 
// Create Playable Connect4 Screen 
// Revamp GameDisplay to have an image of the game on top and then game info below 
// Add Other Games

// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, must_be_immutable, file_names, camel_case_types, use_build_context_synchronously

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Shared/Data.dart';

void AccountCreation(BuildContext context,bool suc) {
  if(!suc){
    ElegantNotification.error(
        width: 360,
        notificationPosition: NotificationPosition.topRight,
        animation: AnimationType.fromRight,
        title: const Text('Error'),
        description: const Text('Account was not made'),
        onDismiss: () {},
      ).show(context);
  } else {
    ElegantNotification.success(
        width: 360,
        notificationPosition: NotificationPosition.topRight,
        animation: AnimationType.fromRight,
        title: const Text('Success'),
        description: const Text('Account made was Created'),
        onDismiss: () {},
      ).show(context);
  }
}

class newAccount extends StatefulWidget {
  newAccount(this.data, this.fontSize, this.glob, {super.key});
  MediaQueryData data;
  Data glob;
  double fontSize;
  @override
  _newAccount createState() => _newAccount(data,fontSize,glob);
}

class _newAccount extends State<newAccount> {
  _newAccount( this.data,this.fontSize, this.glob);
  MediaQueryData data;
  double fontSize;
  Data glob;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 50, 179, 146)),
        child :  makeMenu(data.size.width < data.size.height, context)
      ));
  }

}
Widget makeMenu(bool mobile, BuildContext context) {
  final Name = TextEditingController();
  final Password = TextEditingController();
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(children: [
      secss("Username",Name,mobile,false),
      secss("Password",Password,mobile,true)],),
      createAccountButton(Password,Name,mobile, context),
    ],
  );
}

Widget createAccountButton(TextEditingController name, TextEditingController password, bool mobile, BuildContext context) {
  return InkWell(
    onTap: () {
      createAccound(name.text,password.text, context);
    },
    // ignore: prefer_const_constructors
    child: Container(
      width: 444,
      height: 300,  
      color: const Color.fromARGB(255, 132, 6, 163),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            'Create Account',
            style: TextStyle(color: Colors.white, fontSize: 40),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ));
}

void createAccound(String name, String password, BuildContext context) async {
  String url = "http://139.162.210.205/GameSev/Create?name=$name&password=$password";
  try{
      print("sds");
      final response = await http
    .get(Uri.parse(url));
      if(response.statusCode == 200){
        print(response.body);
        if(response.body == "User Created"){
          print("User Created");
          AccountCreation(context, true);
        }
      } else {
        print(response.body);
        AccountCreation(context, false);
      }
    } on Exception{
      print("Fail");
    }
}


Widget secss(String text, TextEditingController name, bool mobile, bool obs) {
  double width = mobile ? 200 : 350;
  return Padding(
    padding: const EdgeInsets.fromLTRB(30,50,30,50),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 40),),
        SizedBox(
          height: 40,
            width: width,
            child:
              TextField(
                textAlignVertical: TextAlignVertical.top,
                controller: name,
                obscureText: obs,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.black
                ),
                decoration: const InputDecoration(
                  focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),
                  enabledBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60, width: 2.0),
                  ),
                  labelStyle: TextStyle(color: Colors.black)
                )
              )
          )]));
}