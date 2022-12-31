// ignore_for_file: file_names, non_constant_identifier_names, must_be_immutable
import 'package:flutter/material.dart';
import 'package:front/Shared/Data.dart';
import 'package:front/Home/LoginScreen.dart';
import 'package:front/Home/DisplayScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key,required this.data});
  Data data;
  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() => _HomePage(data);
}

class _HomePage extends State<HomePage> {
   Data data;
  _HomePage(this.data );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _body(data)
      ); 
}}

Widget _body(Data data){
  //Logged in
  if(!data.isSet){
    return LoginScreen(data);
  } else {
    return DisplayScreen(data);
  }

}