import 'package:flutter/material.dart';

import 'bigtext.dart';

Widget profileInputWidget({
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
            contentPadding: EdgeInsets.all(20), border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        )),
      )
    ],
  );
}
