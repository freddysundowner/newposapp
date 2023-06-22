import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:printing/printing.dart';
import 'pdf/sales_receipt.dart';

class PdfPreviewPage extends StatelessWidget {
  final invoice;
  String? type;
  FutureOr<Uint8List> widget;
  PdfPreviewPage({Key? key, this.invoice, this.type, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(type ?? ""),
      ),
      body: PdfPreview(
        build: (context) => widget,
      ),
    );
  }
}
