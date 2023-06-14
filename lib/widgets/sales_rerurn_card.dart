import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/sales/components/sales_receipt.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import '../Real/schema.dart';
import '../controllers/sales_controller.dart';
import 'bigtext.dart';

Widget SaleReturnCard(ReceiptItem receiptItem) {
  return InkWell(
    onTap: () {
      Get.to(() => SalesReceipt(
          salesModel: receiptItem.receipt,
          type: "returns",
          from: "customerpage"));
    },
    child: Card(
      child: Container(
        margin: EdgeInsets.all(3),
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning,
              color: Colors.red,
              size: 25,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${receiptItem.product!.name}".capitalize!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          "Receipt# ${receiptItem.receipt?.receiptNumber}"
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Qty :${receiptItem.quantity} @".capitalize!,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              htmlPrice(receiptItem.price),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            Spacer(),
                            Text(
                              "Total:${htmlPrice(receiptItem.quantity! * receiptItem.price!)}",
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    ),
  );
}

showbottomSheet(historyBody, context, salesId) {
  SalesController salesController = Get.find<SalesController>();
  showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          color: Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  if (historyBody.customerId == null) {
                    showSnackBar(
                        message:
                            "You cannot return a product that ha no customer",
                        color: Colors.red);
                  } else {
                    // salesController.returnSale(historyBody, salesId);
                  }
                  Navigator.pop(context);
                },
                contentPadding: EdgeInsets.all(10),
                leading: Icon(
                  Icons.assignment_returned_outlined,
                  color: Colors.black,
                ),
                title: majorTitle(
                    title: "Return to stock", size: 12.0, color: Colors.black),
              )
            ],
          ),
        );
      });
}
