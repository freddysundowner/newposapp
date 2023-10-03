import 'package:flutter/material.dart';

import 'bigtext.dart';

Widget profileInputWidget({required controller, required name,required type}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      majorTitle(title: "$name", color: Colors.black, size: 16.0),
      SizedBox(height: 5),
      TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      )
    ],
  );
}
