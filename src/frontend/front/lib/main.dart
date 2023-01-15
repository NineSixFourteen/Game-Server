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
    WebSocketChannel socket = getSocket();
    return MaterialApp(
      title: 'Proj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
      '/': (context) => Connect4(const Board4(board: [[]], gameDone: false, winner: 0, id: 0, photos: [], players: [], turn: 0),"",2,socket),
      },
      
    );
  }
}

WebSocketChannel getSocket() {
  return WebSocketChannel.connect(Uri.parse('ws://localhost:5083/connect?id=41'));
}

