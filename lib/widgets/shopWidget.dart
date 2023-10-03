import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'bigtext.dart';

Widget profileInputWidget({required controller, required name, required type}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 10),
      majorTitle(title: "$name", color: Colors.black, size: 16.0),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        inputFormatters:type=="number"?[ FilteringTextInputFormatter.digitsOnly
        ]: [],
        keyboardType: type == "email"
            ? TextInputType.emailAddress
            : type == "number"
                ?   TextInputType.number:TextInputType.text
                ,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),

            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      )
    ],
  );
}
