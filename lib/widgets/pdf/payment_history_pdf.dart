import 'dart:io';

import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../Real/Models/schema.dart';

PaymentHistoryPdf(
    {required final shop, required List<PayHistory> deposits}) async {
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
                    "Payment History",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.SizedBox(height: 15.0),
                pw.Expanded(
                    child: pw.Table.fromTextArray(
                        border: pw.TableBorder.all(width: 1), //table border
                        headers: ["Paid", "Balance", "Date"],
                        data: deposits
                            .map((e) => [
                                  e.amountPaid,
                                  e.balance,
                                  DateFormat("dd/MM/yyyy").format(e.createdAt!)
                                ])
                            .toList())),
                pw.SizedBox(height: 10),
              ],
            ),
          );
        },
        pageFormat: PdfPageFormat.a4),
  );

  final bytes = await pdf.save();
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/payment-history.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
