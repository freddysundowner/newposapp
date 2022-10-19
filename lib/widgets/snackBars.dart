import 'package:flutter/material.dart';
import 'package:get/get.dart';

 showSnackBar({required message,required Color color}){
   Get.snackbar("", message,snackPosition: SnackPosition.BOTTOM,backgroundColor: color,colorText: Colors.white);
}