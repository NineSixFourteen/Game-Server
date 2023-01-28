// ignore_for_file: file_names, non_constant_identifier_names, empty_catches

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:front/Home/DisplayScreen.dart';
import 'package:http/http.dart' as http;

import 'NewAccount.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen(this.data, this.isMobile, {super.key});
  Data data;
  bool isMobile;
  Data getData(){
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(isMobile: isMobile,glob: getData()),
    );
  }
}

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login({super.key, required this.isMobile,required this.glob});
  bool isMobile;
  Data glob;
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _Login(isMobile,glob);
}

class _Login extends State<Login> {
  _Login(this.isMobile, this.glob);
  bool isMobile;
  Data glob;

  void move(){
    glob.user = "Test1";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisplayScreen(glob,isMobile)),
    );
  }

  void SignIn(String name, String Password) async{
    try{
      print(name);
      print(Password);
      final response = await http
        .get(Uri.parse('http://139.162.210.205/GameSev/Login?name=$name&pass=$Password'));
        if(response.statusCode == 200){
          print(response.body);
          if(response.body != "Error: User not found") {
            glob.auth = response.body;
            glob.user = name;
            glob.isSet = true;
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisplayScreen(glob,isMobile)),
            );
          }
        } 
    } on Exception{
    }
  }
  final field1 = TextEditingController();
  final field2 = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    field1.dispose();
    field2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double textBoxWidth = 0;
    if(isMobile){
      textBoxWidth = 300;
    } else {
      textBoxWidth = 600;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Login Page"),
      ),
      backgroundColor: const Color.fromARGB(255, 13, 103, 181),
      resizeToAvoidBottomInset: false,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
          Padding(
            padding: const EdgeInsets.only(top:5),
            child: SizedBox(
              width: textBoxWidth,
              height: 100,
              child: Image.asset('assets/images/Logo.png'),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom:10 , left: 2,right: 2),
            child: field("Username",false,textBoxWidth,field1)
          ),
          Padding(
            padding: const EdgeInsets.only(top:10, bottom: 20, left: 1,right: 1),
            child: field("Password",true,textBoxWidth,field2)
          ),
          Container(
            height: 40,
            width: textBoxWidth,
            decoration: BoxDecoration(
              color: Colors.blue, borderRadius: 
              BorderRadius.circular(20)
            ),
            child: ElevatedButton(
              onPressed: ()=>{
                //move()
                SignIn(field1.text,field2.text)
              },
              // ignore: prefer_const_constructors
              child: Text(  
                'login',
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 25),
                ),
            ),
          ),
          Center(
            child: RichText(
              text: TextSpan(
                text: 'Create new Account',
                style: const TextStyle(color: Colors.yellow , fontSize: 18),
                recognizer: TapGestureRecognizer()..onTap = () {
                    showModalBottomSheet(
                      context: context, 
                      builder: (_) => newAccount(isMobile,10,glob)
                    );
                },
              )
          ),
          )
        ])
      ]),
    );
  } 
}

SizedBox field(String message, bool obs,double width, TextEditingController field){
  return 
    SizedBox(
      width: width,
      child:
        TextField(
          controller: field,
          obscureText: obs,
          style: const TextStyle(
            color: Colors.black
          ),
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white60, width: 2.0),
            ),
            labelText: message,
            labelStyle: const TextStyle(color: Colors.black)
          )
        )
    );
}