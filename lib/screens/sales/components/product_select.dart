import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:get/get.dart';

import '../../../controllers/purchase_controller.dart';
import '../../../controllers/sales_controller.dart';

Widget shopcard({required product, required type}) {
  SalesController salesController = Get.find<SalesController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
    child: InkWell(
      onTap: () {
        if (type == "product") {
          if (product.quantity <= 0) {
            Get.snackbar("", "Product is Already Out off Stock");
          } else {
            Get.back();
          }
        } else if (type == "purchase") {
          purchaseController.changeSelectedList(product);
          Get.back();
        } else {
          if (product.quantity <= 0) {
            Get.snackbar("", "Product is Already Out off Stock");
          } else {
            salesController.selecteProduct.value = product;
            salesController.changeSelectedList(product);
            Get.back();
          }
        }
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.white.withOpacity(0.7),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product.name}".capitalize!,
                style: TextStyle(color: Colors.black, fontSize: 17),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "@ ${product.sellingPrice![0]} ${shopController.currentShop.value?.currency}, ${product.quantity} Left",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                product.category.name,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}