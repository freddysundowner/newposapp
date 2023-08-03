import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/financial_page.dart';
import 'package:pointify/screens/product/tabs/receipts_sales.dart';
import 'package:pointify/widgets/months_filter.dart';

import '../../../Real/schema.dart';
import '../../../controllers/sales_controller.dart';
import '../../../functions/functions.dart';
import '../../../pdfFiles/pdf/productmonthlypdf/monthlypreview.dart';
import '../../../pdfFiles/pdf/productmonthlypdf/product_monthly_report.dart';
import '../../../pdfFiles/pdfpreview.dart';
import '../../../utils/colors.dart';

class SalesPages extends StatelessWidget {
  final product;
  SalesController salesController = Get.find<SalesController>();

  SalesPages({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("SALES HISTORY ${salesController.currentYear.value}"),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    htmlPrice(salesController.productSales.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.total!)),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              InkWell(
                onTap: () {
                  isSmallScreen(context)
                      ? Get.to(() => MonthlyPreviewPage(
                          sales: monhts
                              .map((e) => [
                                    e["month"],
                                    htmlPrice(getSalesTotal(e["month"],
                                        salesController.productSales)),
                                  ])
                              .toList(),
                          type: "Product Sales",
                          product: product,
                          title: "Monthly sales for ${product.name!}",
                          total: salesController.productSales.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue! + element.total!)))
                      : Get.find<HomeController>().selectedWidget.value =
                          MonthlyPreviewPage(
                              sales: monhts
                                  .map((e) => [
                                        e["month"],
                                        htmlPrice(getSalesTotal(e["month"],
                                            salesController.productSales)),
                                      ])
                                  .toList(),
                              type: "Product Sales",
                              product: product,
                              title: "Monthly sales for ${product.name!}",
                              total: salesController.productSales.fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue! + element.total!));
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.mainColor),
                  child: const Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: monthsFilter((i) {
            getMonthlyProductSales(product, i, function:
                (Product product, DateTime firstday, DateTime lastday) {
              salesController.filterStartDate.value = firstday;
              salesController.filterEndDate.value = lastday;
              salesController.getSalesByProductId(
                  product: product, fromDate: firstday, toDate: lastday);
              salesController.getReturns(
                  product: product,
                  fromDate: firstday,
                  toDate: lastday,
                  type: "return");
            }, year: salesController.currentYear.value);
            isSmallScreen(context)
                ? Get.to(() => ProductReceiptsSales(
                      product: product,
                      i: i,
                    ))
                : Get.find<HomeController>().selectedWidget.value =
                    ProductReceiptsSales(
                    product: product,
                    i: i,
                  );
          }, counts: (month) {
            return "${_getSalesCount(month)} sales";
          }, totals: (month) => "${htmlPrice(_getSalesTotal(month))}/="),
        )
      ],
    );
  }

  _getSalesCount(String month) {
    return salesController.productSales
        .where((p0) => _getDate("MMMM", p0.soldOn!) == month)
        .length;
  }

  _getSalesTotal(String month) {
    return salesController.productSales
        .where((p0) => _getDate("MMMM", p0.soldOn!) == month)
        .fold(0, (previousValue, element) => previousValue + element.total!);
  }

  _getDate(String format, int date) {
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date));
  }
}
