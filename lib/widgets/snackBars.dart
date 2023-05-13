import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar({required message, required Color color}) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    content: Text(
      "${message}",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
  ));
}
