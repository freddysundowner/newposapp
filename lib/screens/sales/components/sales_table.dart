import 'package:flutter/material.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/home_controller.dart';
import '../../../models/receipt.dart';
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
      child: DataTable(
        decoration: BoxDecoration(
            border: Border.all(
          width: 1,
          color: Colors.black,
        )),
        columnSpacing: 30.0,
        columns: [
          DataColumn(
              label: Text('Receipt Number', textAlign: TextAlign.center)),
          DataColumn(
              label: Text(
                  'Amount(${shopController.currentShop.value?.currency})',
                  textAlign: TextAlign.center)),
          DataColumn(
              label: Text('Payment Method', textAlign: TextAlign.center)),
          DataColumn(label: Text('Date', textAlign: TextAlign.center)),
          DataColumn(label: Text('', textAlign: TextAlign.center)),
        ],
        rows: List.generate(
            page != "home"
                ? salesController.allSales.length
                : salesController.allSales.length == 0
                    ? 0
                    : salesController.allSales.length > 4
                        ? 4
                        : salesController.allSales.length, (index) {
          SalesModel salesModel = salesController.allSales.elementAt(index);
          final y = salesModel.receiptNumber;
          final x = salesModel.grandTotal.toString();
          final z = salesModel.paymentMethod;
          final w = salesModel.createdAt;

          return DataRow(cells: [
            DataCell(Container(width: 75, child: Text(y!))),
            DataCell(Container(width: 75, child: Text(x))),
            DataCell(Container(child: Text(z!))),
            DataCell(Container(
                child: Text(DateFormat("yyyy-dd-MMM hh:mm a").format(w!)))),
            DataCell(InkWell(
              onTap: () {
                Get.find<HomeController>().selectedWidget.value = SaleOrderItem(
                  id: salesModel.id,
                  page: page,
                );
              },
              child: Container(
                  child: Text(
                "View",
                style: TextStyle(color: AppColors.mainColor),
              )),
            )),
          ]);
        }),
      ),
    ),
  );
}
