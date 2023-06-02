import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

Widget majorTitle({required title, required Color color, required size}) {
  return Text(
    "$title",
    style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size),
  );
}
