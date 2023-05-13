import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/receipt_item.dart';
import 'package:pointify/widgets/alert.dart';

import '../../../controllers/purchase_controller.dart';
import '../../../controllers/sales_controller.dart';

Widget productCard(
    {required ProductModel product, required type, Function? function}) {
  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
    child: InkWell(
      onTap: () {
        if (type == "product") {
          if (product.quantity! <= 0) {
            generalAlert(title: "Alert", message: "Product out of stock");
          } else {
            Get.back();
          }
        } else if (type == "purchase") {
          purchaseController.changesaleItem(product);
          Get.back();
        } else if (type == "badstock") {
          if (product.quantity! <= 0) {
            generalAlert(title: "Alert", message: "Product out of stock");
            return;
          }
          function!(product);
        } else {
          if (product.quantity! <= 0) {
            generalAlert(title: "Alert", message: "Product out of stock");
          } else {
            print("b");
            function!(product);
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
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                product.category!.name!,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
