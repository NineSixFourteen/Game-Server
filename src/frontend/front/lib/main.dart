import 'package:front/Home/Home.dart';
import 'package:front/Shared/Data.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'Connect4/Board4.dart';
import 'Connect4/Connect4Gui.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  Data data = Data();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
      '/': (context) => HomePage(data: data,),
      },
      
    );
  }
}

