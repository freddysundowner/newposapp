import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/pdfFiles/pdf/productmonthlypdf/product_monthly_report.dart';

import 'package:pointify/pdfFiles/pdf/productmonthlypdf/product_monthly_report.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/utils/colors.dart';
import 'package:printing/printing.dart';
import '../../../Real/schema.dart';
import '../../../screens/product/product_history.dart';
import '../../../screens/product/tabs/product_sales.dart';
import '../sales_receipt.dart';

class MonthlyPreviewPage extends StatelessWidget {
  var sales;
  String? type;
  String? title;
  int? total;
  Product? product;

  MonthlyPreviewPage(
      {Key? key,
      this.sales,
      this.type,
      required this.product,
      this.title,
      this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              isSmallScreen(context)
                  ? Get.back()
                  : Get.find<HomeController>().selectedWidget.value =
                      ProductHistory(product: product!);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isSmallScreen(context) ? Colors.white : Colors.black,
            )),
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        title: Text(
          type ?? "",
          style: TextStyle(
              color: isSmallScreen(context) ? Colors.white : Colors.black),
        ),
      ),
      body: PdfPreview(
        build: (context) => ProductMonthlyReport(sales,
            product: product!, title: title, total: total),
      ),
    );
  }
}
