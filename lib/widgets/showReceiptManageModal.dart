import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Real/schema.dart';
import '../controllers/sales_controller.dart';
import '../screens/sales/components/sales_receipt.dart';

showReceiptManageModal(context, ReceiptItem receiptItem) {
  SalesController salesController = Get.find<SalesController>();

  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Container(child: Text('Manage Receipts'))],
              ),
            ),
            if (receiptItem.type != "return")
              ListTile(
                  leading: Icon(Icons.list),
                  onTap: () {
                    salesController.currentReceipt.value = receiptItem.receipt;
                    returnReceiptItem(receiptItem: receiptItem);
                  },
                  title: const Text('Return Sale')),
            ListTile(
                leading: Icon(Icons.delete),
                onTap: () {},
                title: Text('Delete')),
            ListTile(
                leading: Icon(Icons.clear),
                onTap: () {
                  Get.back();
                },
                title: const Text('Close')),
          ],
        );
      });
}
