import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

CashFlowPdf(
    {required final shop,
    required type,
    required currency,
    required cashInHand,
    required cashIn,
    required cashOut}) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
        build: (context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(10),
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
                    "Cashflow Records",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.SizedBox(height: 15.0),
                pw.Row(children: [
                  pw.Row(children: [
                    pw.Text("Cash in Hand ",
                        style: pw.TextStyle(color: PdfColor.fromHex("#FFFRRR")))
                  ])
                ]),
                pw.SizedBox(height: 15.0),
                // pw.Table.fromTextArray(
                //     border: pw.TableBorder.all(width: 1), //table border
                //     headers: [
                //       "Cash At Hand",
                //       "Amount",
                //       "Payment Meethod",
                //       "Date"
                //     ],
                //     data: []),
                pw.SizedBox(height: 10),
              ],
            ),
          );
        },
        pageFormat: PdfPageFormat.a4),
  );

  final bytes = await pdf.save();
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$shop-barcode.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
