import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pointify/pdfFiles/pdf/product_monthly_report.dart';
import 'package:printing/printing.dart';
import '../../../Real/schema.dart';
import '../sales_receipt.dart';

class MonthlyPreviewPage extends StatelessWidget {
  final sales;
  String? type;
  Product? product;
  MonthlyPreviewPage({Key? key, this.sales, this.type, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type ?? ""),
      ),
      body: PdfPreview(
        build: (context) => ProductMonthlyReport(sales, product: product!),
      ),
    );
  }
}
