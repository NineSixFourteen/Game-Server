// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';

Widget filter(MediaQueryData data, List<String> filters, Function change, List<String> playerNames) {
  double width;
  double height;
  double fontSize;
  if(data.size.width < data.size.height){
    width = 400;
    height = 100;
    fontSize = 20;
  } else {
    width = 935;
    height = 100;
    fontSize = 24;
  }
  return SizedBox(
    width: width,
    height: height,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height,
            width: width/3,
            child: TextSec("Player",playerNames, data.size.width < data.size.height, fontSize, change, 0, filters),
          ),
          SizedBox(
            height: height,
            width: width/3,
            child: TextSec("Result",["All","Win","Lose","Draw","Incomplete"], data.size.width < data.size.height, fontSize, change, 1, filters),
          ),
          SizedBox(
            height: height,
            width: width/3,
            child: TextSec("Gamemode",['All', 'TicTacToe', 'Connect4', ], data.size.width < data.size.height, fontSize, change, 2, filters),
          ),
        ],
      )
    )
  );
}
Widget TextSec(String title, List<String> options, bool mobile, double fontSize, Function change, int val, List<String> filters){
  if(!mobile){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: TextFieldHelper(title, options, fontSize, change, val, filters)
  );
  } else {
    return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: TextFieldHelper(title, options, fontSize, change, val, filters)
  );
  }
}

List<Widget> TextFieldHelper(String title, List<String> options, double fontSize, Function change, int val, List<String> filters){
  return [
      Text("$title: ", style: TextStyle(fontSize: fontSize)),
      Container(
        decoration: BoxDecoration(color: Colors.grey[00]),
        child: 
      DropdownButton(
        style: TextStyle(color: const Color.fromARGB(255, 17, 65, 97), fontSize: fontSize, ),
        alignment: Alignment.center,
        value: filters[val],
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
            change(val, newValue!);
        },
      ))
    ];
}