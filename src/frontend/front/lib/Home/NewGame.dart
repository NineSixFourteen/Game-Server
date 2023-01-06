// ignore_for_file: file_names

import 'package:flutter/material.dart';

Widget newGame(MediaQueryData data, BuildContext context, List<String> playerNames) {
  double width;
  if(data.size.width < data.size.height){
    width = 370;
  } else {
    width = 900;
  }
  return Padding(
    padding: const EdgeInsets.fromLTRB(0,10,0,5),
    child:ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blueGrey),
      ),
      child:  Row(
        children: [
          SizedBox(
            width:  width,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/plus.png",
                width: 100,
                height: 150,),
                const Text(
                  "Create new Game", 
                  style: TextStyle(color: Colors.white, fontSize: 20)
                )
              ])
            ),
    ]),
      onPressed: () => {
        showModalBottomSheet(
          context: context, 
          builder: (BuildContext context){
            return SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("")
                ],
              ),
            );
          })
      },
  ));
}