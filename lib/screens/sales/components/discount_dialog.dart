import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';

import '../../../widgets/snackBars.dart';

discountDialog({required context,required controller, required ProductModel productModel,required index}) {
  SalesController salesController = Get.find<SalesController>();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Discount"),
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
                if (int.parse(controller.text) >
                    (productModel.discount! *
                        productModel.cartquantity!)) {
                  showSnackBar(
                      message:
                      "discount cannot be greater than ${productModel
                          .discount! * productModel.cartquantity!}",
                      color: Colors.red,
                      context: context);
                } else {
                  productModel.allowedDiscount = int.parse(controller.text);
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