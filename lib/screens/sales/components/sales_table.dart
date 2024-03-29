import 'package:flutter/material.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/screens/sales/components/sales_receipt.dart';

import '../../../Real/schema.dart';
import '../../../controllers/home_controller.dart';
import '../../../functions/functions.dart';
import '../../../utils/colors.dart';
import '../sale_order_item.dart';

Widget salesTable({required context, required page, String? type}) {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            headingTextStyle: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            dataTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Colors.black,
            )),
            columnSpacing: 30.0,
            columns: [
              const DataColumn(
                  label: Text('Receipt Number',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis)),
              DataColumn(
                  label: Text(
                      'Amount(${shopController.currentShop.value?.currency})',
                      textAlign: TextAlign.center)),
              const DataColumn(
                  label: Text(
                'Payment Method',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )),
              const DataColumn(
                  label: Text('Cashier', textAlign: TextAlign.center)),
              const DataColumn(
                  label: Text('Date', textAlign: TextAlign.center)),
              const DataColumn(
                  label: Text('Actions', textAlign: TextAlign.center)),
            ],
            rows: List.generate(
                page != "home"
                    ? salesController.allSales.length
                    : salesController.allSales.isEmpty
                        ? 0
                        : salesController.allSales.length > 4
                            ? 4
                            : salesController.allSales.length, (index) {
              SalesModel salesModel = salesController.allSales.elementAt(index);
              final y = salesModel.receiptNumber;
              final h = salesModel.attendantId?.username == null
                  ? " "
                  : salesModel.attendantId?.username?.capitalize;
              final x = htmlPrice(salesModel.items.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.quantity!) >
                      0
                  ? salesModel.grandTotal
                  : salesModel.returneditems.fold(
                      0,
                      (previousValue, element) =>
                          previousValue +
                          (element.price! * element.quantity!)));
              final z = salesModel.paymentMethod;
              final w = salesModel.createdAt;

              return DataRow(cells: [
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("#${y!}".toUpperCase()),
                    if (salesModel.returneditems.isNotEmpty)
                      Text(
                        "${salesModel.returneditems.length} item Returned",
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                )),
                DataCell(Text(x)),
                DataCell(Text(z!)),
                DataCell(Text(h!)),
                DataCell(Text(DateFormat("yyyy-dd-MMM ").format(w!))),
                DataCell(InkWell(
                  onTap: () {
                    Get.find<HomeController>().selectedWidget.value =
                        SalesReceipt(
                      salesModel: salesModel,
                      type: "",
                      from: page,
                    );
                  },
                  child: Text(
                    "View",
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                )),
              ]);
            }),
          ),
        ),
      ),
    ),
  );
}

Widget salesReturnTable({required context, String? type}) {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            headingTextStyle: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            dataTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Colors.black,
            )),
            columnSpacing: 30.0,
            columns: [
              const DataColumn(
                  label: Text('Receipt Number',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis)),
              DataColumn(
                  label: Text(
                      'Amount(${shopController.currentShop.value?.currency})',
                      textAlign: TextAlign.center)),
              const DataColumn(
                  label: Text(
                'Payment Method',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )),
              const DataColumn(
                  label: Text('Quantity', textAlign: TextAlign.center)),
              const DataColumn(
                  label: Text('Date', textAlign: TextAlign.center)),
            ],
            rows: List.generate(salesController.currentReceiptReturns.length,
                (index) {
              ReceiptItem salesModel =
                  salesController.currentReceiptReturns.elementAt(index);

              final y = salesModel.receipt!.receiptNumber!;
              final h = salesModel.quantity.toString();
              final x = salesModel.total.toString();
              final z = salesModel.receipt!.paymentMethod.toString();
              final w = salesModel.receipt!.createdAt!;

              return DataRow(cells: [
                DataCell(Text("#${y!}".toUpperCase())),
                DataCell(Text(x)),
                DataCell(Text(z)),
                DataCell(Text(h!)),
                DataCell(Text(DateFormat("yyyy-dd-MM").format(w!))),
              ]);
            }),
          ),
        ),
      ),
    ),
  );
}
