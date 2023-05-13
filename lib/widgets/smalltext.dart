import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';

Widget minorTitle({required title, required Color color, double? size}) {
  return Text(
    "${title}",
    style: TextStyle(color: color, fontSize: size ?? 14),
  );
}
