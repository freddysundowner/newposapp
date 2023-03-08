import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../screens/sales/sale_order_item.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget soldCard({required SalesModel salesModel}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      Get.to(() => SaleOrderItem(id: salesModel.id));
    },
    child: Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Expanded(
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
                          title: "Sale No:#${salesModel.receiptNumber}",
                          color: Colors.black,
                          size: 12.0),
                      SizedBox(height: 3),
                      normalText(
                          title:
                              "Amount: ${shopController.currentShop.value?.currency}.${salesModel.grandTotal}",
                          color: Colors.black,
                          size: 14.0),
                      SizedBox(height: 3),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // minorTitle(title: "", color: Colors.black),
                      SizedBox(height: 3),
                      // minorTitle(
                      //     title: "Sold by:${salesModel.attendantid!.fullnames!}",
                      //     color: Colors.black),
                      SizedBox(height: 3),
                      minorTitle(
                          title: "Paid via: ${salesModel.paymentMethod}",
                          color: Colors.black),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Expanded(
                child: minorTitle(
                    title:
                        "On :${DateFormat("yyyy-MM-dd hh :mm a").format(salesModel.createdAt!)}",
                    color: Colors.black)),
          ],
        ),
      ),
    ),
  );
}
