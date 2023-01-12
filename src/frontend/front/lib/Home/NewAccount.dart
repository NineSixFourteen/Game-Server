
// ignore_for_file: no_logic_in_create_state, library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Shared/Data.dart';

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
        child :  makeMenu(data.size.width < data.size.height)
      ));
  }

}
Widget makeMenu(bool mobile) {
  final Name = TextEditingController();
  final Password = TextEditingController();
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(children: [
      secss("Username",Name,mobile,false),
      secss("Password",Password,mobile,true)],),
      createAccountButton(Password,Name,mobile),
    ],
  );
}

Widget createAccountButton(TextEditingController name, TextEditingController password, bool mobile) {
  return InkWell(
    onTap: () {
      createAccound(name.text,password.text);
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

void createAccound(String name, String password) async {
  String url = "https://game-sev.azurewebsites.net/Create?name=$name&password=$password";
  try{
      final response = await http
    .get(Uri.parse(url));
      if(response.statusCode == 200){
        if(response.body == "User Created"){
          print("User Created");
        }
      } else {
        print(response.body);
        print("Fial");
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