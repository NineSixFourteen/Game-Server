// ignore_for_file: non_constant_identifier_names, file_names
import 'package:front/Shared/TextSelc.dart';
import 'package:flutter/material.dart';

Widget filter(MediaQueryData data, List<String> filters, Function change, List<String> playerNames) {
  double width;
  double height;
  double fontSize;
  if(data.size.width < data.size.height){
    width = 400;
    height = 150;
    fontSize = 20;
  } else {
    width = 935;
    height = 150;
    fontSize = 24;
  }
  return SizedBox(
    width: width,
    height: height,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Column(
        children: [
          SizedBox(height: height/20,),
          SizedBox(
            width: width - 8,
            height: height * 0.25,
            child: Container(
                decoration: BoxDecoration(color: Colors.black,boxShadow: [BoxShadow(
                  color: Colors.grey[850]!,
                  offset: const Offset(0,0),
                  blurRadius: 1.0,
                  spreadRadius: 1.0)]),
                child: const Text("Filter", style: const TextStyle(fontSize: 25, color: Colors.greenAccent),textAlign: TextAlign.center)
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.7,
                width: width/3,
                child: TextSec("Player",playerNames, data.size.width < data.size.height, fontSize, change, 0, filters),
              ),
              SizedBox(
                height: height * 0.7,
                width: width/3,
                child: TextSec("Result",["All","Win","Lose","Draw","Incomplete"], data.size.width < data.size.height, fontSize, change, 1, filters),
              ),
              SizedBox(
                height: height * 0.7,
                width: width/3,
                child: TextSec("Gamemode",['All', 'TicTacToe', 'Connect4', ], data.size.width < data.size.height, fontSize, change, 2, filters),
              ),
            ],
          )
      ]))
  );
}
