// ignore_for_file: file_names

import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 103, 181),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
          Padding(
            padding: const EdgeInsets.only(top:60.0),
            child: SizedBox(
              width: 500,
              height: 300,
              child: Image.asset(
                'assets/images/Logo.png',
              ),
            )
          ),
           Padding(
            padding: const EdgeInsets.only(top:20, bottom: 20, left: 10,right: 10),
            child: field("Username",false)
            ),
          Padding(
            padding: const EdgeInsets.only(top:20, bottom: 20, left: 10,right: 10),
            child: field("Password",true)
            ),
          Container(
            height: 50,
            width: 600,
            decoration: BoxDecoration(
              color: Colors.blue, borderRadius: 
              BorderRadius.circular(20)
            ),
            child: ElevatedButton(
              onPressed: (){},
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

SizedBox field(String message, bool obs){
  return 
    SizedBox(
      width: 600,
      child:
        TextField(
          obscureText: obs,
          style: const TextStyle(
            color: Colors.yellow
          ),
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70, width: 2.0),
            ),
            labelText: message,
            labelStyle: const TextStyle(color: Colors.blueGrey)
          )
        )
    );
}