import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/shop_controller.dart';

Widget productHistoryContainer(productBody) {
  ShopController shopController = Get.find<ShopController>();
  return Padding(
    padding: const EdgeInsets.all(3.0),
    child: Card(
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${productBody.product!.name}".capitalize!,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        // Text(
                        //   "${productBody.product!.category ?? ""}",
                        //   style: TextStyle(color: Colors.grey, fontSize: 16),
                        // ),
                        Text('Qty ${productBody.quantity}'),
                        Text(
                            '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                      ],
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text(
                        'BP/=  ${shopController.currentShop.value?.currency}.${productBody.product!.buyingPrice}'),
                    Text(
                        'SP/=  ${shopController.currentShop.value?.currency}.${productBody.product!.sellingPrice![0]}')
                  ],
                )
              ],
            )),
      ),
    ),
  );
}