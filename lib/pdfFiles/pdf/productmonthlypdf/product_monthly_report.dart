import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/widgets/months_filter.dart';

import '../../widgets/normal_text.dart';

Future<Uint8List> ProductMonthlyReport(List<ReceiptItem> receipts,
    {required Product product}) async {
  ShopController shopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();
  final pdf = Document();
  pdf.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(shopController.currentShop.value!.name!,
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              Center(
                  child: Text("Monthly sales for ${product.name!}",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center)),
              SizedBox(height: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "as of ${DateFormat("yyy-MM-dd").format(productController.filterStartDate.value)}"),
                    SizedBox(height: 10),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total Cash: "),
                          Text(
                              htmlPrice(receipts.fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue + element.total!)),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16))
                        ]),
                  ]),
              SizedBox(height: 20),
              Expanded(
                  child: Column(children: [
                TableHelper.fromTextArray(
                    border: TableBorder.all(width: 1), //table border
                    headers: [
                      "MONTH",
                      "SALES",
                    ],
                    data: monhts
                        .map((e) => [
                              e["month"],
                              htmlPrice(getSalesTotal(e["month"], receipts)),
                            ])
                        .toList())
              ])),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
}

getSalesTotal(String month, productSales) {
  return productSales
      .where((p0) => getDate("MMMM", p0.soldOn!) == month)
      .fold(0, (previousValue, element) => previousValue + element.total!);
}

getDate(String format, int date) {
  return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date));
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
