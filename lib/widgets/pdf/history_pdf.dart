import 'dart:io';

import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../Real/schema.dart';

HistoryPdf(
    {required final shop,
    required final name,
    required List<BankTransactions> sales}) async {
  int sum = 0;
  for (var element in sales) {
    sum += element.amount!;
  }
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    "${shop}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Center(
                  child: pw.Text(
                    "$name History",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.SizedBox(height: 15.0),
                pw.Expanded(
                    child: pw.Table.fromTextArray(
                        border: pw.TableBorder.all(width: 1), //table border
                        headers: ["Amount", "Date"],
                        data: sales
                            .map((e) => [
                                  "${Get.find<ShopController>().currentShop.value?.currency} ${e.amount}",
                                  DateFormat("dd/MM/yyyy").format(e.createdAt!)
                                ])
                            .toList())),
                pw.SizedBox(height: 10),
                pw.Align(
                  alignment: pw.Alignment.topRight,
                  child: pw.SizedBox(
                      width: 200,
                      child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(
                              "Totals ${Get.find<ShopController>().currentShop.value?.currency} ${sum}",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold, fontSize: 16),
                            ),
                            pw.Divider(
                                thickness: 1,
                                color: const PdfColor.fromInt(0xFF000000))
                          ])),
                ),
                pw.SizedBox(height: 10),
              ],
            ),
          );
        },
        pageFormat: PdfPageFormat.a4),
  );

  final bytes = await pdf.save();
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$name-history.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
