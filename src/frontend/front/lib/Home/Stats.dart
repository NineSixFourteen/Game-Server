// ignore_for_file: unnecessary_import, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

SizedBox Boxx(String head, List<int> vals, bool isMobile, bool Per){
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
  if(isMobile){
    height = 96;
    width = 199;
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
    width = 500;
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

StatsBody(bool isMobile,List<List<int>> info) {
  return Row(
    children: [
      Column(
        children:  [
          Boxx("Games Played",info[0],isMobile,false),
          Boxx("Wins",info[2], isMobile,false),
          Boxx("Draws",info[3], isMobile,false)
        ],
      ),
      Column(
        children: [
          Boxx("Win Rate",info[1],isMobile,true ),
          Boxx("Losses",info[4], isMobile,false),
          Boxx("Incomplete",info[5], isMobile,false)
        ])]);
} 


Widget CardC(Widget head, Widget bod, bool isMobile,BoxDecoration decoration){
  double width;
  double height;
  if(isMobile){
    width = 400;
    height = 360;
  } else{
    width = 1000;
    height = 300;
  }
  return Card(child: Container(  
    decoration: decoration,
    child: SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [head,bod]
      )
    )
  ));
}

Widget CardHeading(String text, double fontSize){
  return Text(
    text,
    textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.greenAccent,
        fontSize: fontSize,
        fontWeight: FontWeight.bold));
}

BoxDecoration defaultHead(){
  return BoxDecoration(
    color: Colors.black,
    boxShadow: [
      BoxShadow(
        color: Colors.grey[850]!,
        offset: const Offset(0,0),
        blurRadius: 1.0,
        spreadRadius: 1.0)
    ]);
}

Widget StatsHeading(BoxDecoration dec, bool isMobile){
  double width;
  if(isMobile){
    width = 390;
  }else{
    width = 990;
  }
  return Row(
    children: [
      Card(
        color: Colors.black,
        elevation: 1,
        child: SizedBox(
          width: width, height: 40,
          child: 
            Container(
              decoration: dec,
            child:CardHeading("Stats", 30)
      )))]);
}