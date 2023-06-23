import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Column tabView({required String title, var subtitle}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 13, color: Colors.black),
      ),
      Text(
        subtitle ?? "",
        style: const TextStyle(fontSize: 11, color: Colors.black),
      ),
    ],
  );
}
