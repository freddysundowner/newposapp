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

              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "From ${DateFormat("yyy-MM-dd").format(productController.filterStartDate.value)} to ${DateFormat("yyy-MM-dd").format(productController.filterEndDate.value)}"),
                    Row(children: [
                      Text("Total Cash mm:"),
                      Text(
                          htmlPrice(receipts.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.total!)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16))
                    ]),
                  ]),
              // SizedBox(height: 20),
              // if (invoice.customerId != null)
              //   Row(children: [
              //     Text("No:"),
              //     Text(invoice.customerId!.fullName!.toUpperCase(),
              //         style:
              //             TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              //   ]),
              // SizedBox(height: 20),
              // Expanded(
              //     child: TableHelper.fromTextArray(
              //         border: TableBorder.all(width: 1), //table border
              //         headers: [
              //           "Qty",
              //           "Description",
              //           "Price",
              //         ],
              //         data: invoice.items
              //             .map((e) => [
              //                   e.receipt!.quantity,
              //                   "${e.product!.name}",
              //                   htmlPrice(e.price),
              //                 ])
              //             .toList())),
              // SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: SizedBox(
              //       width: 200,
              //       child: Column(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             Text(
              //               "Totals ${htmlPrice(invoice.grandTotal)}",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold, fontSize: 16),
              //             ),
              //             Divider(
              //                 thickness: 1,
              //                 color: const PdfColor.fromInt(0xFF000000))
              //           ])),
              // ),
              // SizedBox(height: 10),
              // Text("Served by : ${invoice.attendantId!.username!}"),
              // Spacer(),
              // Align(
              //     alignment: Alignment.center,
              //     child:
              //         Text("Thank you!", style: const TextStyle(fontSize: 28)))
            ],
          ),
        );
      },
    ),
  );
  return pdf.save();
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
