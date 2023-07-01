import 'package:flutter/material.dart';
import 'package:get/get.dart';

deleteDialog({required context, required onPressed}) {
  return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Confirm Delete",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text("Do you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                onPressed();
                Get.back();
              },
              child: Text(
                "Ok Delete".toUpperCase(),
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}
