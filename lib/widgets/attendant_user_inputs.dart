import 'package:flutter/material.dart';

import 'bigtext.dart';
Widget attendantUserInputs({required name, required controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      majorTitle(
          title:name, color: Colors.black, size: 14.0),
      SizedBox(height: 10),
      TextFormField(
        controller: controller,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(10),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      )
    ],
  );
}