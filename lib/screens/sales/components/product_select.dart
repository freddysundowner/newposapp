import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/widgets/alert.dart';

import '../../../Real/schema.dart';
import '../../../controllers/purchase_controller.dart';

Widget productListItemCard(
    {required Product product, required type, Function? function}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
    child: InkWell(
      onTap: () {
        print(type);
        if (type == "purchase") {
          function!(product);
        } else {
          if (product.quantity == 0) {
            generalAlert(title: "Error", message: "Out of stock");
            return;
          }
          function!(product);
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
                "@ ${htmlPrice(product.selling)}, ${product.quantity} Left",
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
