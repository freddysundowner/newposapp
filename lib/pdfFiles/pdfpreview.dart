import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/utils/colors.dart';
import 'package:printing/printing.dart';
import '../screens/sales/components/sales_receipt.dart';
import 'pdf/sales_receipt.dart';

class PdfPreviewPage extends StatelessWidget {
  final invoice;
  String? type;

  PdfPreviewPage({Key? key, this.invoice, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        leading: IconButton(
            onPressed: () {
              isSmallScreen(context)
                  ? Get.back()
                  : Get.find<HomeController>().selectedWidget.value =
                      SalesReceipt(
                      salesModel: invoice,
                      type: "return",
                    );
            },
            icon: Icon(Icons.arrow_back_ios,
                color: isSmallScreen(context) ? Colors.white : Colors.black)),
        title: Text(
          type ?? "",
          style: TextStyle(
              color: isSmallScreen(context) ? Colors.white : Colors.black),
        ),
      ),
      body: PdfPreview(
        build: (context) => salesReceipt(invoice, type ?? ""),
      ),
    );
  }
}
