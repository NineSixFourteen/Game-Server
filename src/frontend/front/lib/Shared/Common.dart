// ignore_for_file: file_names

import 'package:flutter/material.dart';

Text displayText(String message){
  return Text(message,
            // ignore: prefer_const_constructors
            style: TextStyle(
              color: Colors.white, 
              fontSize: 35,
            )
  );
}