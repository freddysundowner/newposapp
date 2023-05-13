import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';

generalAlert(
        {String? title,
        String message = "",
        Function? function,
        String positiveText = "Okay",
        String negativeText = "Cancel"}) =>
    showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertDialog(
            title: Text(title!),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    negativeText,
                    style: TextStyle(color: AppColors.mainColor),
                  )),
              TextButton(
                  onPressed: () {
                    Get.back();
                    function!();
                  },
                  child: Text(
                    positiveText,
                    style: TextStyle(color: AppColors.mainColor),
                  ))
            ],
          );
        });
