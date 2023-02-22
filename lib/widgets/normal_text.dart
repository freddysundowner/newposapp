import 'package:flutter/material.dart';

Widget normalText({required title, required Color color, required size}) {
  return Text(
    "${title}",
    style: TextStyle(color: color, fontSize: size),
  );
}
