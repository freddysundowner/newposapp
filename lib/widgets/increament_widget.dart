import 'package:flutter/material.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';
import '../utils/colors.dart';

Widget incrementWidget({required ProductModel product, required index, required context}) {
  ProductController productController = Get.find<ProductController>();
  productController.initialProductValue.value = product.quantity!;

  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name!),
                Text('System Count'),
                Text('${product.quantity}')
              ],
            ),
            Column(
              children: [
                Text(""),
                Text('Physical Count'),
                Row(children: [
                  IconButton(
                      onPressed: () {
                        productController.decreamentInitial(index);
                      },
                      icon: Icon(Icons.remove)),
                  Text('${product.quantity}'),
                  IconButton(
                      onPressed: () {
                        productController.increamentInitial(index);
                      },
                      icon: Icon(Icons.add))
                ])
              ],
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                          "Confirm Product Count",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // content: Text("Do you want to delete this item?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              productController.updateQuantity(product);
                              Get.back();
                            },
                            child: Text(
                              "Okay".toUpperCase(),
                              style: TextStyle(
                                color: AppColors.mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [Icon(Icons.check), Text('OK')],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}