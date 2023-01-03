// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

Widget CardC(Widget head, Widget bod, MediaQueryData data, BoxDecoration decoration){
  double width;
  double height;
  if(data.size.width > data.size.height){
    width = data.size.width/1.35;
    height = data.size.height/2.4;
  } else{
    width = data.size.width/1.1;
  height = data.size.height/2.4;
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

Widget StatsHeading(BoxDecoration dec, MediaQueryData data){
  double width;
  if(data.size.width > data.size.height){
    width = data.size.width/1.364;
  }else{
    width = data.size.width/1.13;
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
            child:CardHeading("Stats", data.size.height/25)
      )))]);
}