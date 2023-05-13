import 'dart:io';

import 'package:pointify/models/cashflow_summary.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

CashFlowPdf({
  required final shop,
  required type,
  required currency,
  required date,
  required CashflowSummary cashflowSummary,
}) async {
  List data = [
    {
      "name": "Total Cashinhand",
      "data": cashflowSummary.cashinhand,
    },
    {
      "name": "TotalCashout",
      "data": cashflowSummary.totalcashout,
    },
    {
      "name": "TotalCashin",
      "data": cashflowSummary.totalcashin,
    },
    {
      "name": "TotalWallet",
      "data": cashflowSummary.totalwallet,
    },
    {
      "name": "TotalBanked",
      "data": cashflowSummary.totalbanked,
    },
    {
      "name": "TotalSales",
      "data": cashflowSummary.totalSales,
    },
    {
      "name": "TotalPurchases",
      "data": cashflowSummary.totalpurchases,
    },
    {
      "name": "TotalExpenses",
      "data": cashflowSummary.totalExpenses,
    },
  ];
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
                    "${shop}".toUpperCase(),
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
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text("As On: ",
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFF000000),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 15)),
                      pw.Text("${date}",
                          style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFF000000),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 15))
                    ]),
                pw.SizedBox(height: 15.0),
                pw.Table.fromTextArray(
                    border: pw.TableBorder.all(width: 1), //table border
                    headers: [
                      "Name",
                      "Amount($currency)",
                    ],
                    data: data.map((e) => [e["name"], e["data"]]).toList()),
                pw.SizedBox(height: 10),
              ],
            ),
          );
        },
        pageFormat: PdfPageFormat.a4),
  );

  final bytes = await pdf.save();
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$shop-Cashflow.pdf');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}
