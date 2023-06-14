import 'package:flutter/material.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:get/get.dart';

import '../../../Real/schema.dart';
import '../../../widgets/snackBars.dart';

showEditDialogPrice({required Product productModel, required index}) {
  SalesController salesController = Get.find<SalesController>();
  showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Selling Price"),
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
                controller: salesController.textEditingSellingPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
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
                if (int.parse(
                        "${salesController.textEditingSellingPrice.text}") <
                    int.parse("${productModel.minPrice}")) {
                  showSnackBar(
                      message:
                          "selling price cannot be below${productModel.minPrice}",
                      color: Colors.red);
                } else if (int.parse(
                        "${salesController.textEditingSellingPrice.text}") >
                    int.parse("${productModel.sellingPrice![0]}")) {
                  showSnackBar(
                      message:
                          "selling price cannot be above${productModel.sellingPrice![0]}",
                      color: Colors.red);
                } else {
                  productModel.selling =
                      int.parse(salesController.textEditingSellingPrice.text);
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
