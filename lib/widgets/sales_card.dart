import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/sales/components/sales_receipt.dart';
import 'package:pointify/screens/suppliers/supplier_info_page.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Real/schema.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget SalesCard({required SalesModel salesModel}) {
  return InkWell(
    onTap: () {
      Get.to(() => SalesReceipt(
            salesModel: salesModel,
            type: "",
          ));
    },
    child: Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
      width:
          MediaQuery.of(Get.context!).size.width < 600 ? double.infinity : 400,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
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
                      "Total: ${htmlPrice(salesModel.items.fold(0, (previousValue, element) => previousValue + element.quantity!) > 0 ? salesModel.grandTotal : salesModel.returneditems.fold(0, (previousValue, element) => previousValue + (element.price! * element.quantity!)))}",
                  color: Colors.black,
                  size: 14.0),
              SizedBox(height: 3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  minorTitle(
                      title:
                          "sold on: ${DateFormat("yyyy-MM-dd hh:mm").format(salesModel.createdAt!)}",
                      color: Colors.black),
                ],
              ),
              if (salesModel.returnsCount != null &&
                  salesModel.returnsCount! > 0)
                InkWell(
                  onTap: () {
                    Get.to(() => SalesReceipt(
                          salesModel: salesModel,
                          type: "returns",
                        ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.file_download,
                          color: Colors.orange,
                          size: 12,
                        ),
                        Text(
                          "View Returns (${salesModel.returneditems.fold(0, (previousValue, element) => previousValue + element.quantity!)})",
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
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
                      "Cashier: ${salesModel.attendantId?.username?.capitalize}",
                  color: Colors.black),
              SizedBox(height: 3),
              minorTitle(
                  title: "Paid via: ${salesModel.paymentMethod}",
                  color: Colors.black),
              if (showUnpaidBadge(salesModel)) const SizedBox(height: 5),
              if (showUnpaidBadge(salesModel))
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Column(
                    children: [
                      minorTitle(
                          title:
                              "Unpaid: ${htmlPrice(salesModel.creditTotal!.abs())}",
                          color: Colors.red),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

bool showUnpaidBadge(SalesModel salesModel) {
  return salesModel.creditTotal! > 0 &&
      salesModel.items.fold(0,
              (previousValue, element) => previousValue + element.quantity!) >
          0;
}
