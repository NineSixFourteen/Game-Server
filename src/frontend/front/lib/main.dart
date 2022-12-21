import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proj',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicToe(title: 'Home Page'),
    );
  }
}

class TicToe extends StatefulWidget {
  const TicToe({super.key, required this.title});
  final String title;

  @override
  State<TicToe> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<TicToe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed:(){}
          )
        ],
        title: const Align(
          alignment: Alignment.center,
          child:Text('Tic Tac Toe',textAlign: TextAlign.center,) 
          )
      ),
      backgroundColor: Colors.black45,
      body: Column(
          children: [
            _buildPointsTable(),
            _buildGrid()
          ]
          ),
    );
  }
}

Text displayTex(String message){
  return Text(message,
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Colors.white, 
              fontSize: 35,
            )
  );
}

Widget tile(int val){
  const red = MaterialStatePropertyAll<Color>(Colors.red);
  const blue = MaterialStatePropertyAll<Color>(Colors.blue);
  var color = MaterialStatePropertyAll<Color>(Colors.grey[900]!);
  var msg = " ";
  if(val == 1){
    color = red;
    msg = "X";
  } else if(val == 2){
      color = blue;
      msg = "O";
  }
  return SizedBox(
    height: 150,
    width:  150,
    child: Padding(
        padding: EdgeInsets.all(10),
        child:ElevatedButton(
        style: ButtonStyle(
          backgroundColor: color,
        ),
        onPressed: (){}, 
          child: Text(
            msg,
            style: const TextStyle(fontSize: 100, color: Colors.white),
        )))
      );
}

Widget _buildPointsTable(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.all(12.0),
        child:Column(
          children: [
            displayTex("Player 0"),
            displayTex("Score 50"),
          ])),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child:Column(
          children: [
          displayTex("Player 1"),
          displayTex("Score 100")
        ])),
    ]
  );
}

Widget _buildGrid(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Column(
                children: [
                  tile(1),
                  tile(2),
                  tile(2)
                ],
              ),
              Column(
                children: [
                  tile(1),
                  tile(0),
                  tile(2)
                ],
              ),
              Column(
                children: [
                  tile(2),
                  tile(0),
                  tile(1)
                ],
              ),
            ],
            )
    )
    ]);
}