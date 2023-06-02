import 'package:flutter/material.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:get/get.dart';

import '../../../Real/Models/schema.dart';
import '../../../widgets/snackBars.dart';

discountDialog(
    {required controller, required ReceiptItem receiptItem, required index}) {
  SalesController salesController = Get.find<SalesController>();
  return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Discount"),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "0",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ))),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                print(receiptItem.product!.discount);
                if (int.parse(controller.text) >
                    receiptItem.product!.discount!) {
                  showSnackBar(
                      message:
                          "discount cannot be greater than ${receiptItem.product!.discount}",
                      color: Colors.red);
                } else {
                  receiptItem.discount = int.parse(controller.text);
                  controller.text = "";
                  salesController.calculateAmount(index);
                }
              },
              child: Text(
                "Save now".toUpperCase(),
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      });
}
