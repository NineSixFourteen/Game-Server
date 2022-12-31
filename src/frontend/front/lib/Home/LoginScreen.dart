// ignore_for_file: file_names, non_constant_identifier_names, empty_catches

import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:front/Home/DisplayScreen.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen(this.data, {super.key});
  Data data;
  Data getData(){
    return data;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    MediaQueryData queryData = MediaQuery.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(data: queryData,glob: getData()),
    );
  }
}

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login({super.key, required this.data,required this.glob});
  MediaQueryData data;
  Data glob;
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _Login(data,glob);
}

class _Login extends State<Login> {
  _Login(this.data, this.glob);
  MediaQueryData data;
  Data glob;

  void move(){
    Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisplayScreen(glob)),
            );
  }

  void SignIn(String name, String Password) async{
    try{
      // ignore: unused_local_variable
      final response = await http
        .get(Uri.parse('http://localhost:5083/Login?name=$name&pass=$Password'));
        print(response.body);
        if(response.statusCode == 200){
          print(response.body);
          if(response.body != "Error: User not found") {
            glob.auth = response.body;
            glob.user = name;
            glob.isSet = true;
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DisplayScreen(glob)),
            );
          }
        } 
    } catch (Exception){
      print(Exception);
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
    if(data.size.width < data.size.height){
      textBoxWidth = data.size.width/1.2;
    } else {
      textBoxWidth = data.size.width/2.4;
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
            padding: EdgeInsets.only(top:data.size.height/200),
            child: SizedBox(
              width: textBoxWidth,
              height: data.size.height/4,
              child: Image.asset('assets/images/Logo.png'),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: data.size.height/100, bottom:data.size.height/100 , left: 2,right: 2),
            child: field("Username",false,textBoxWidth,field1)
          ),
          Padding(
            padding: EdgeInsets.only(top:data.size.height/100, bottom: data.size.height/50, left: 1,right: 1),
            child: field("Password",true,textBoxWidth,field2)
          ),
          Container(
            height: data.size.height/18,
            width: textBoxWidth,
            decoration: BoxDecoration(
              color: Colors.blue, borderRadius: 
              BorderRadius.circular(20)
            ),
            child: ElevatedButton(
              onPressed: ()=>{
                move()
                //SignIn(field1.text,field2.text)
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