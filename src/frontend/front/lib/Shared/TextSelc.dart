// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

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