import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/AuthController.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

logoutAccountDialog(context) {
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Logout"),
          content: majorTitle(
              title: "You will be logout from you account",
              color: Colors.grey,
              size: 14.0),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: majorTitle(
                    title: "Cancel", color: AppColors.mainColor, size: 16.0)),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.find<AuthController>().logout();
                },
                child: majorTitle(
                    title: "Logout", color: AppColors.mainColor, size: 16.0))
          ],
        );
      });
  ;
}