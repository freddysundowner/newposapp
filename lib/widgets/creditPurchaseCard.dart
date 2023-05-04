import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/screens/stock/purchase_order_item.dart';
import 'package:flutterpos/widgets/pdf/payment_history_pdf.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/CustomerController.dart';
import '../controllers/home_controller.dart';
import '../controllers/purchase_controller.dart';
import '../models/purchase_order.dart';
import '../screens/cash_flow/payment_history.dart';

Widget CreditPurchaseHistoryCard(context, PurchaseOrder salesBody) {
  return InkWell(
    onTap: () {
      showBottomSheet(context, salesBody);
    },
    child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Icon(Icons.arrow_downward, color: Colors.red),
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${salesBody.receiptNumber}"),
                Text("Date: ${DateFormat().format(salesBody.createdAt!)}"),
                Text("Quantity: ${salesBody.productCount}"),
                Text(
                  "Due: ${salesBody.balance}",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            Spacer(),
            Align(
                child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )),
          ],
        )),
  );
}

showBottomSheet(BuildContext context, PurchaseOrder salesBody) {
  SalesController salesController = Get.find<SalesController>();
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.7),
                    child: Text('Select Action')),
                ListTile(
                  leading: Icon(Icons.list),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => PurchaseOrderItems(
                          id: salesBody.id,
                          page: "customer_info",
                        ));
                  },
                  title: Text('View Purchases'),
                ),
                if (salesBody.balance! > 0)
                  ListTile(
                    leading: Icon(Icons.payment),
                    onTap: () {
                      Navigator.pop(context);

                      showAmountDialog(context, salesBody);
                    },
                    title: Text('Pay'),
                  ),
                ListTile(
                  leading: Icon(Icons.wallet),
                  onTap: () {
                    Navigator.pop(context);
                    if (MediaQuery.of(context).size.width > 600) {
                      Get.find<HomeController>().selectedWidget.value =
                          PaymentHistory(
                        id: salesBody.id!,
                      );
                    } else {
                      Get.to(() =>
                          PaymentHistory(id: salesBody.id!, type: "purchase"));
                    }
                  },
                  title: Text('Payment History'),
                ),
                ListTile(
                  leading: Icon(Icons.file_copy_outlined),
                  onTap: () async {
                    Navigator.pop(context);
                    await salesController.getPaymentHistory(
                        id: salesBody.id!, type: "purchase");

                    PaymentHistoryPdf(
                        shop:
                            Get.find<ShopController>().currentShop.value!.name,
                        deposits: salesController.paymenHistory.value);
                  },
                  title: Text('Generate Report'),
                ),
              ],
            )));
      });
}

showAmountDialog(context, PurchaseOrder salesBody) {
  CustomerController customerController = Get.find<CustomerController>();
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "Enter Amount",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: customerController.amountController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "eg ${salesBody.total}",
                      hintStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                )
              ],
            )),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (salesBody.balance! <
                    int.parse(customerController.amountController.text)) {
                } else {
                  Get.find<PurchaseController>().paySupplierCredit(
                    amount: customerController.amountController.text,
                    salesBody: salesBody,
                  );
                }
              },
              child: Text(
                "Save".toUpperCase(),
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}