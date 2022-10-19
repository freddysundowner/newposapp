import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

Widget minorTitle({required title, required Color color}) {
  return Text(
    "${title}".capitalize!,
    style: TextStyle(color: color, fontSize: 14),
  );
}