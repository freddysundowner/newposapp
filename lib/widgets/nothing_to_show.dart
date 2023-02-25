import 'package:flutter/material.dart';

Widget nothingToShow(){
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "!",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "Nothing found",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Text(
          "Try again later",
          style: TextStyle(color: Colors.grey),
        )
      ],
    ),
  );
}