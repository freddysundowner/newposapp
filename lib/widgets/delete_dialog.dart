import 'package:flutter/material.dart';
import 'package:get/get.dart';

deleteDialog({required context, required onPressed}) {
  return
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "Confirm Delete",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("Do you want to delete this item?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".toUpperCase(),
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  onPressed();

                },
                child: Text(
                  "Ok Delete".toUpperCase(),
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
}
