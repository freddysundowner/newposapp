import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/widgets/purchase_order_card.dart';

import '../Real/schema.dart';
import '../controllers/home_controller.dart';
import '../functions/functions.dart';
import '../screens/purchases/invoice_screen.dart';
import '../utils/colors.dart';

Widget invoiceTable({required context}) {
  PurchaseController purchaseController = Get.find<PurchaseController>();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    width: double.infinity,
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            headingTextStyle: const TextStyle(fontSize:16,color: Colors.black,fontWeight: FontWeight.bold),
            dataTextStyle: const TextStyle(fontSize: 16,color: Colors.black),
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Colors.black,
            )),
            columnSpacing: 30.0,
            columns: const [
              DataColumn(label: Text('Invoice', textAlign: TextAlign.center)),
              DataColumn(label: Text('Amount', textAlign: TextAlign.center)),
              DataColumn(label: Text('Products', textAlign: TextAlign.center)),
              DataColumn(label: Text('Status', textAlign: TextAlign.center)),
              DataColumn(label: Text('Unpaid', textAlign: TextAlign.center)),
              DataColumn(label: Text('Date', textAlign: TextAlign.center)),
              DataColumn(label: Text('Action', textAlign: TextAlign.center)),
            ],
            rows: List.generate(purchaseController.purchasedItems.length,
                (index) {
              Invoice invoice =
                  purchaseController.purchasedItems.elementAt(index);

              final y = invoice.receiptNumber;
              final x = invoice.productCount;
              final z = invoice.total;
              final a = invoice.createdAt!;

              return DataRow(cells: [
                DataCell(Text("#${y!}")),
                DataCell(Text(z.toString())),
                DataCell(Text(x.toString())),
                DataCell(Text(
                  chechPayment(invoice),
                  style: TextStyle(color: chechPaymentColor(invoice)),
                )),
                DataCell(Text(
                  htmlPrice(invoice.balance),
                  style: TextStyle(
                      color: invoice.balance! < 0 ? Colors.red : Colors.black),
                )),
                DataCell(Text(DateFormat("dd-MM-yyyy").format(a))),
                DataCell(Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.0),
                  child: InkWell(
                      onTap: () {
                        Get.find<HomeController>().selectedWidget.value =
                            InvoiceScreen(
                          invoice: invoice,
                          type: "",
                        );
                      },
                      child: Text(
                        "View",
                        style: TextStyle(color: AppColors.mainColor),
                      )),
                )),
              ]);
            }),
          ),
        ),
      ),
    ),
  );
}
