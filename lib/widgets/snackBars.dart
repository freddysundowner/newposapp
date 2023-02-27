import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar({required message, required Color color,required context}) {
  // Get.snackbar("", message,
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: color,
  //     colorText: Colors.white);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      "${message}",
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
  ));
}
