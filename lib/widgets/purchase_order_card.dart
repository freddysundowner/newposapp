import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/stock/invoice_screen.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/invoice.dart';
import 'normal_text.dart';

Widget InvoiceCard({required Invoice invoice, String? tab}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      Get.to(() => InvoiceScreen(
            invoice: invoice,
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
                    Text(
                      "Invoice#${invoice.receiptNumber}",
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        if (tab != "credit")
                          normalText(
                              title:
                                  "Amount: ${shopController.currentShop.value?.currency}.${invoice.total}",
                              color: Colors.black,
                              size: 14.0),
                        if (tab == "credit")
                          normalText(
                              title:
                                  "Amount: ${shopController.currentShop.value?.currency}.${invoice.balance}",
                              color: Colors.black,
                              size: 14.0),
                        SizedBox(width: 30),
                        minorTitle(
                            title: "Products: ${invoice.productCount}",
                            color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          normalText(
              title:
                  "On :${DateFormat("yyyy-MM-dd hh:mm a").format(invoice.createdAt!)}",
              color: Colors.black,
              size: 14.0),
        ],
      ),
    ),
  );
}
