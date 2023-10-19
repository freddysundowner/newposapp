import 'package:flutter/material.dart';

deleteShopDialog(context, onclicked) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Delete this Shop"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: const TextStyle(
                    color: Colors.purple, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onclicked();
              },
              child: Text(
                "Delete".toUpperCase(),
                style:
                const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            )
          ],
        );
      });
}