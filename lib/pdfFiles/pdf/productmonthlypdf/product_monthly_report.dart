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

import '../../../functions/functions.dart';


Future<Uint8List> ProductMonthlyReport(data,
    {required Product product, String? title, int? total}) async {
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
                  child: Text(title ?? "",
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
                          Text("Total: "),
                          Text(htmlPrice(total ?? 0),
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
                      "TOTAL",
                    ],
                    data: data)
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

getSalesTotal(String month, data, {String? type}) {
  if (type != null) {
    if (type == "stockin") {
      List<InvoiceItem> invoices = data as List<InvoiceItem>;
      return invoices
          .where((p0) =>
              getDate("MMMM", p0.createdAt!.millisecondsSinceEpoch) == month)
          .fold(0, (previousValue, element) => previousValue + element.total!);
    }
    if (type == "badstock") {
      List<BadStock> invoices = data as List<BadStock>;
      return invoices
          .where((p0) =>
              getDate("MMMM", p0.createdAt!.millisecondsSinceEpoch) == month)
          .fold(
              0,
              (previousValue, element) =>
                  previousValue +
                  (element.quantity! * element.product!.buyingPrice!));
    }
  }
  return data
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
