import 'package:front/Shared/Data.dart';
import 'package:front/Home/Home.dart';

import 'TicTac/TicTacGui.dart';
import 'package:flutter/material.dart';

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
      '/': (context) => HomePage(data: data),
      '/Tic' :(context) => TicToeGame(data: data,)
      },
      
    );
  }
}

