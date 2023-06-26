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

Widget salesTable(context, page) {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.grey),
      child: Expanded(
        child: DataTable(
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.black,
          )),
          columnSpacing: 30.0,
          columns: [
            const DataColumn(
                label: Text('Receipt Number', textAlign: TextAlign.center)),

            DataColumn(
                label: Text(
                    'Amount(${shopController.currentShop.value?.currency})',
                    textAlign: TextAlign.center)),
            const DataColumn(
                label: Text('Payment Method', textAlign: TextAlign.center)),
            const DataColumn(label: Text('Date', textAlign: TextAlign.center)),
            const DataColumn(label: Text('', textAlign: TextAlign.center)),
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
            final h = salesModel.attendantId?.username?.capitalize;
            final x =htmlPrice(salesModel.items.fold(0, (previousValue, element) => previousValue + element.quantity!) > 0 ? salesModel.grandTotal : salesModel.returneditems.fold(0, (previousValue, element) => previousValue + (element.price! * element.quantity!)));
            final z = salesModel.paymentMethod;
            final w = salesModel.createdAt;

            return DataRow(cells: [
              DataCell(Text(y!)),

              DataCell(Text(x)),
              DataCell(Text(z!)),
              DataCell(Text(DateFormat("yyyy-dd-MMM ").format(w!))),
              DataCell(InkWell(
                onTap: () {
                  Get.find<HomeController>().selectedWidget.value = SalesReceipt(
                    salesModel: salesModel,
                    type: "",
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
  );
}
