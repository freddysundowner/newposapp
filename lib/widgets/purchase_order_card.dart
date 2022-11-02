import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/purchase_order.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../screens/stock/purchase_order_item.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget purchaseOrderCard({required PurchaseOrder purchaseOrder}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      Get.to(() => PurchaseOrderItems(
            id: purchaseOrder.id,
          ));
    },
    child: Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title: "Purchase No:#${purchaseOrder.receiptNumber}",
                        color: Colors.black,
                        size: 12.0),
                    SizedBox(height: 3),
                    normalText(
                        title:
                            "Amount: ${shopController.currentShop.value?.currency}.${purchaseOrder.total}",
                        color: Colors.black,
                        size: 14.0),
                    SizedBox(height: 3),
                    minorTitle(
                        title: "Products: ${purchaseOrder.productCount}",
                        color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          normalText(
              title:
                  "On :${DateFormat("yyyy-MM-dd hh :mm a").format(purchaseOrder.createdAt!)}",
              color: Colors.black,
              size: 14.0),
        ],
      ),
    ),
  );
}
