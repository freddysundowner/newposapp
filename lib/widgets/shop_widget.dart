import 'package:flutter/material.dart';

import 'bigtext.dart';

Widget shopWidget({
  required controller,
  required name,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      majorTitle(title: "$name", color: Colors.black, size: 16.0),
      SizedBox(height: 5),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1)),
        ),
      )
    ],
  );
}
