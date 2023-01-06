// ignore_for_file: unnecessary_import, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

SizedBox Boxx(String head, List<int> vals, MediaQueryData data, bool Per){
  int total = vals[0];
  int tic = vals[1];
  int row = vals[2];
  Column text;
  double width;
  double height;
  String msg;
  if(Per){
    msg = "Total: $total%\n  TictacToe: $tic%\n  Connect4: $row%";
  } else { 
    msg = "Total: $total\n  TictacToe: $tic\n  Connect4: $row" ;
  }
  if(data.size.width < data.size.height){
    height = 96;
    width = data.size.width/2.22;
    text = Column(
      children: [
      Text(
          head,
          style: const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 21, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      Text(
      msg,
      style: const TextStyle(color: Colors.white, fontSize: 19),
      textAlign: TextAlign.center,
    )]);
  } else{
    height = 78;
    width = data.size.width/2.7;
    text = Column(
      children: [
        Text(
          head,
          style: const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 31, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          "Total: $total TictacToe: $tic Connect4: $row",
          style: const TextStyle(color: Color.fromARGB(255, 254, 254, 254), fontSize: 27, ),
          textAlign: TextAlign.center,
        )
      ]);
  } 
  return SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,0,0,0),
          child: text
        )
      );
}

StatsBody(MediaQueryData data,List<List<int>> info) {
  return Row(
    children: [
      Column(
        children:  [
          Boxx("Games Played",info[0],data,false),
          Boxx("Wins",info[2], data,false),
          Boxx("Draws",info[3], data,false)
        ],
      ),
      Column(
        children: [
          Boxx("Win Rate",info[1],data,true ),
          Boxx("Losses",info[4], data,false),
          Boxx("Incomplete",info[5], data,false)
        ])]);
} 


