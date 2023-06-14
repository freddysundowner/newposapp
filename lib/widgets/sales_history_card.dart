import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/sales/components/return_stock.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import '../Real/schema.dart';
import '../controllers/sales_controller.dart';
import 'bigtext.dart';

Widget SaleOrderItemCard(InvoiceItem invoiceItem, page) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      if (page != "returns") {
        returnInvoiceItem(invoiceItem: invoiceItem);
      }
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
              color: page == "credit" || page == "returns"
                  ? Colors.red
                  : Colors.green,
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
                          "${invoiceItem.product!.name}".capitalize!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          "Receipt# ${invoiceItem.sale!.receiptNumber}"
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
                              "Qty :${invoiceItem.itemCount} @".capitalize!,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "${shopController.currentShop.value?.currency}.${invoiceItem.price!}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                            Spacer(),
                            Text(
                              "Total:${shopController.currentShop.value?.currency}.${invoiceItem.total}",
                              style: TextStyle(
                                  color: page == "credit"
                                      ? Colors.yellow
                                      : Colors.green,
                                  fontSize: 16),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        if (invoiceItem.sale!.creditTotal! > 0 &&
                            page != "returns")
                          Row(
                            children: [
                              Text(
                                "${invoiceItem.returnedItems} item returned",
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "View",
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      Icon(
                                        Icons.receipt_long,
                                        size: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
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
