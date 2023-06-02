import 'package:flutter/material.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:get/get.dart';
import 'package:pointify/utils/themer.dart';
import 'package:pointify/widgets/alert.dart';

import '../../../Real/Models/schema.dart';
import '../../../utils/colors.dart';

returnInvoiceItem({required InvoiceItem invoiceItem, Invoice? invoice}) {
  PurchaseController purchaseController = Get.find<PurchaseController>();
  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = invoiceItem.itemCount.toString();
  return showDialog(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          title: const Text("Return Product?"),
          content: Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              controller: textEditingController,
              decoration: ThemeHelper()
                  .textInputDecorationDesktop('Quantity', 'Enter quantity'),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".toUpperCase(),
                  style: TextStyle(color: AppColors.mainColor),
                )),
            TextButton(
                onPressed: () {
                  if (invoiceItem.itemCount! <
                      int.parse(textEditingController.text)) {
                    generalAlert(
                        title: "Error",
                        message:
                            "You cannot return more than ${invoiceItem.itemCount}");
                  } else if (int.parse(textEditingController.text) <= 0) {
                    generalAlert(
                        title: "Error",
                        message: "You must atleast return 1 item");
                  } else {
                    Get.back();
                    purchaseController.returnInvoiceItem(invoiceItem,
                        int.parse(textEditingController.text), invoice!);
                  }
                },
                child: Text(
                  "Okay".toUpperCase(),
                  style: TextStyle(color: AppColors.mainColor),
                ))
          ],
        );
      });
}
