import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

BarcodePdf({
  required final shop,
  required productname,
}) async {
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
                    "${productname} Barcode",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Text(
                    "As On-${DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.now())}",
                    style: pw.TextStyle(),
                  ),
                ),
                pw.SizedBox(height: 15.0),
                pw.Center(child: pw.Container(
                  color: PdfColors.white,
                  padding:pw.EdgeInsets.all(16),
                  child: pw.BarcodeWidget(
                      data: productname,
                      barcode: Barcode.code128(),
                      width: 200,
                      height: 200,
                      drawText: false),
                ))
                ,
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
