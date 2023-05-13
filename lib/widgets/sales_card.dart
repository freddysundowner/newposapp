import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/receipt.dart';
import 'package:pointify/screens/sales/components/sales_receipt.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget SalesCard({required SalesModel salesModel}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      Get.to(() => SalesReceipt(
            salesModel: salesModel,
          ));
    },
    child: Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      width:
          MediaQuery.of(Get.context!).size.width < 600 ? double.infinity : 400,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  majorTitle(
                      title:
                          "Receipt #${(salesModel.receiptNumber)?.toUpperCase()}",
                      color: Colors.black,
                      size: 12.0),
                  SizedBox(height: 3),
                  normalText(
                      title:
                          "Amount: ${shopController.currentShop.value?.currency}.${salesModel.grandTotal}",
                      color: Colors.black,
                      size: 14.0),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      minorTitle(
                          title:
                              "sold on: ${DateFormat("yyyy-MM-dd hh:mm").format(salesModel.createdAt!)}",
                          color: Colors.black),
                      SizedBox(
                        width: 20,
                      ),
                      if (salesModel.returnedItems!.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.file_download,
                              color: Colors.red,
                              size: 12,
                            ),
                            Text(
                              "${salesModel.returnedItems?.length}",
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3),
                  minorTitle(
                      title:
                          "Cashier: ${salesModel.attendantId?.fullnames?.capitalize}",
                      color: Colors.black),
                  SizedBox(height: 3),
                  minorTitle(
                      title: "Paid via: ${salesModel.paymentMethod}",
                      color: Colors.black),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
