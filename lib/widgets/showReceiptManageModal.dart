import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/widgets/alert.dart';

import '../Real/schema.dart';
import '../controllers/sales_controller.dart';
import '../screens/sales/components/sales_receipt.dart';

showReceiptManageModal(context, ReceiptItem receiptItem, Product product) {
  SalesController salesController = Get.find<SalesController>();
  return showModalBottomSheet<void>(
      context: context,
      backgroundColor:
          isSmallScreen(context) ? Colors.white : Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          margin: EdgeInsets.only(
              left: isSmallScreen(context)
                  ? 0
                  : MediaQuery.of(context).size.width * 0.2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('Manage Receipts')],
                ),
              ),
              ListTile(
                  leading: Icon(Icons.list),
                  onTap: () {
                    Get.back();
                    salesController.getSalesBySaleId(id: receiptItem.receiptId);
                    returnReceiptItem(
                        receiptItem: receiptItem, product: product);
                  },
                  title: const Text('Return Sale')),
              ListTile(
                  leading: Icon(Icons.delete),
                  onTap: () {
                    Get.back();
                    generalAlert(
                        message: "Are you sure you want to delete this receipt",
                        function: () {
                          salesController.getSalesBySaleId(
                              id: receiptItem.receiptId);
                          salesController.deleteReceiptItem(receiptItem,
                              product: product);
                          Get.back();
                        });
                    // salesController.getSalesBySaleId(id: receiptItem.receiptId);
                    // returnReceiptItem(receiptItem: receiptItem, product: product);
                  },
                  title: Text('Delete')),
              ListTile(
                  leading: Icon(Icons.clear),
                  onTap: () {
                    Get.back();
                  },
                  title: const Text('Close')),
            ],
          ),
        );
      });
}
