import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/purchases/invoice_screen.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Real/schema.dart';
import 'normal_text.dart';

Widget InvoiceCard({required Invoice invoice, String? tab}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      Get.to(() => InvoiceScreen(
            invoice: invoice,
            type: "",
          ));
    },
    child: Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Invoice# ${invoice.receiptNumber}".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold),
                        ),
                        if (invoice.balance! < 0 &&
                            invoice.items.fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue + element.itemCount!) >
                                0)
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(5)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            child: Column(
                              children: [
                                minorTitle(
                                    title:
                                        "Unpaid: ${htmlPrice(invoice.balance)}",
                                    color: Colors.red),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        normalText(
                            title:
                                "Amount: ${htmlPrice(invoice.items.fold(0, (previousValue, element) => previousValue + (element.price! * element.itemCount!)) == 0 ? invoice.returneditems.fold(0, (previousValue, element) => previousValue + (element.price! * element.itemCount!)) : invoice.items.fold(0, (previousValue, element) => previousValue + (element.price! * element.itemCount!)))}",
                            color: Colors.black,
                            size: 14.0),
                        const SizedBox(width: 30),
                        minorTitle(
                            title:
                                "Products: ${invoice.items.fold(0, (previousValue, element) => previousValue + element.itemCount!) > 0 ? invoice.items.fold(0, (previousValue, element) => previousValue + element.itemCount!) : invoice.returneditems.fold(0, (previousValue, element) => previousValue + element.itemCount!)}",
                            color: Colors.black),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              normalText(
                  title:
                      "On :${DateFormat("yyyy-MM-dd hh:mm a").format(invoice.createdAt!)}",
                  color: Colors.black,
                  size: 14.0),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: chechPaymentColor(invoice),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  chechPayment(invoice),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

String chechPayment(Invoice salesModel) {
  if (salesModel.total == 0) return "RETURNED";
  if (salesModel.balance == 0) return "PAID";
  if (salesModel.balance! < 0) return "NOT PAID";
  return "";
}

Color chechPaymentColor(Invoice invoice) {
  if (invoice.total! == 0) return Colors.red;
  if (invoice.balance == 0) return Colors.green;
  if (invoice.balance! < 0) return Colors.red;
  return Colors.black;
}
