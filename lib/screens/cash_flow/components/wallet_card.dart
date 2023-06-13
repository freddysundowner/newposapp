import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:intl/intl.dart';

import '../../../Real/Models/schema.dart';
import '../../sales/components/sales_receipt.dart';

Widget WalletUsageCard(
    {required DepositModel depositBody,
    required context,
    required uid,
    customer}) {
  return InkWell(
    onTap: () {
      if (depositBody.receipt != null) {
        Get.to(() => SalesReceipt(
              salesModel: depositBody.receipt,
              type: "",
            ));
      }
    },
    child: Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            depositBody.type == "usage"
                ? Icons.arrow_upward
                : depositBody.receipt != null
                    ? Icons.compare_arrows
                    : Icons.arrow_downward,
            color: depositBody.type == "usage"
                ? Colors.red
                : depositBody.receipt != null
                    ? Colors.amber
                    : Colors.green,
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat().format(depositBody.createdAt!)),
              SizedBox(height: 10),
              Text("Receipt:#${depositBody.recieptNumber.toString()}"),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(Get.find<ShopController>().currentShop.value!.currency!),
                  Text(
                    " ${depositBody.amount}",
                    style: TextStyle(
                      color: depositBody.type == "usage"
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
              if (depositBody.attendant != null)
                Row(
                  children: [
                    Text("By"),
                    Text(
                      " ${depositBody.attendant?.username}",
                      style: TextStyle(
                        color: depositBody.type == "usage"
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              if (depositBody.receipt != null && depositBody.type == "deposit")
                Text(
                  "refund".capitalize!,
                  style: TextStyle(color: Colors.amber),
                )
            ],
          ),
        ],
      ),
    ),
  );
}
