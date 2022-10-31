import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';

import '../controllers/sales_controller.dart';
import '../models/sales_order_item_model.dart';
import 'bigtext.dart';

Widget salesHistoryCard(
    SaleOrderItemModel salesOrderItemModel, context, salesId, page) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      if (page != "credit") {
        if (salesOrderItemModel.returned != true) {
          showbottomSheet(salesOrderItemModel, context, salesId);
        }
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
              color: page == "credit"
                  ? Colors.green
                  : salesOrderItemModel.returned == true
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
                    Text(
                      "${salesOrderItemModel.product!.name}".capitalize!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Qty :${salesOrderItemModel.itemCount}".capitalize!,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Price : ${shopController.currentShop.value?.currency}.${salesOrderItemModel.price!}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    if (page != "credit" &&
                        salesOrderItemModel.returned == true)
                      Text(
                        "Product has been returned to stock",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Sub total= ${shopController.currentShop.value?.currency}.${salesOrderItemModel.total}",
                          style: TextStyle(
                              color: page == "credit"
                                  ? Colors.yellow
                                  : salesOrderItemModel.returned == true
                                      ? Colors.red
                                      : Colors.green,
                              fontSize: 16),
                        )),
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
                contentPadding: EdgeInsets.all(0),
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
