import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:realm/realm.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Real/schema.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/product_controller.dart';
import '../../../functions/functions.dart';
import '../../../pdfFiles/pdf/productmonthlypdf/monthlypreview.dart';
import '../../../pdfFiles/pdf/productmonthlypdf/product_monthly_report.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_filter.dart';
import '../../../widgets/months_filter.dart';
import '../components/product_history_card.dart';
import '../product_history.dart';

class ProductBadStcokHistory extends StatelessWidget {
  Product? product;
  ProductController productController = Get.find<ProductController>();

  ProductBadStcokHistory({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "BAD STOCK HISTORY ${productController.currentYear.value}"),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    htmlPrice(productController.badstocks.fold(
                        0,
                        (previousValue, element) =>
                            previousValue +
                            (element.quantity! *
                                element.product!.buyingPrice!))),
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
                                    htmlPrice(getSalesTotal(
                                        e["month"], productController.badstocks,
                                        type: "badstock")),
                                  ])
                              .toList(),
                          type: "Product Bad Stock",
                          product: product,
                          title: "Monthly bad stock for ${product!.name!}",
                          total: productController.badstocks.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue! +
                                  (element.quantity! *
                                      element.product!.buyingPrice!))))
                      : Get.find<HomeController>().selectedWidget.value =
                          MonthlyPreviewPage(
                              sales: monhts
                                  .map((e) => [
                                        e["month"],
                                        htmlPrice(getSalesTotal(e["month"],
                                            productController.badstocks,
                                            type: "badstock")),
                                      ])
                                  .toList(),
                              type: "Product Bad Stock",
                              product: product,
                              title: "Monthly bad stock for ${product!.name!}",
                              total: productController.badstocks.fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue! +
                                      (element.quantity! *
                                          element.product!.buyingPrice!)));
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
            getMonthlyProductSales(product!, i, function:
                (Product product, DateTime firstday, DateTime lastday) {
              productController.filterStartDate.value = firstday;
              productController.filterEndDate.value = lastday;
              productController.getBadStock(
                  product: product, fromDate: firstday, toDate: lastday);
            }, year: productController.currentYear.value);
            isSmallScreen(context)
                ? Get.to(() => BadStockHistory(
                      product: product!,
                      i: i,
                    ))
                : Get.find<HomeController>().selectedWidget.value =
                    BadStockHistory(
                    product: product!,
                    i: i,
                  );
          }, counts: (month) {
            return "${_getSalesCount(month)} Entries";
          }, totals: (month) => "${htmlPrice(_getSalesTotal(month))}/="),
        ),
      ],
    );
  }

  _getSalesCount(String month) {
    return productController.badstocks
        .where((p0) => _getDate("MMMM", p0.date!) == month)
        .length;
  }

  _getSalesTotal(String month) {
    return productController.badstocks
        .where((p0) => _getDate("MMMM", p0.date!) == month)
        .fold(
            0,
            (previousValue, element) =>
                previousValue +
                (element.quantity! * element.product!.buyingPrice!));
  }

  _getDate(String format, int date) {
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date));
  }
}

class BadStockHistory extends StatelessWidget {
  Product product;
  int i;

  BadStockHistory({Key? key, required this.product, required this.i})
      : super(key: key);
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () {
            getYearlyRecords(product, function: (Product product,
                DateTime firstDayofYear, DateTime lastDayofYear) {
              productController.getBadStock(
                  product: product,
                  fromDate: firstDayofYear,
                  toDate: lastDayofYear);
            }, year: productController.currentYear.value);
            isSmallScreen(context)
                ? Get.back()
                : Get.find<HomeController>().selectedWidget.value =
                    ProductHistory(product: product);
          },
          icon: Icon(Icons.arrow_back_ios,
              color: isSmallScreen(context) ? Colors.white : Colors.black),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bad stock",
              style: TextStyle(
                  fontSize: 16,
                  color: isSmallScreen(context) ? Colors.white : Colors.black),
            ),
            Text(
              product.name!,
              style: TextStyle(
                  fontSize: 12,
                  color: isSmallScreen(context) ? Colors.white : Colors.black),
            )
          ],
        ),
        actions: [
          Icon(
            Icons.picture_as_pdf,
            color: isSmallScreen(context) ? Colors.white : Colors.black,
            size: 25,
          ),
          IconButton(
              onPressed: () async {
                isSmallScreen(context)
                    ? Get.to(() => DateFilter(from: "BadStockHistory",
                          product: product,
                          i: i,
                          function: (value) {
                            if (value is PickerDateRange) {
                              final DateTime rangeStartDate = value.startDate!;
                              final DateTime rangeEndDate = value.endDate!;
                              productController.filterStartDate.value =
                                  rangeStartDate;
                              productController.filterEndDate.value =
                                  rangeEndDate;
                            } else if (value is DateTime) {
                              final DateTime selectedDate = value;
                              productController.filterStartDate.value =
                                  selectedDate;
                              productController.filterEndDate.value =
                                  selectedDate;
                            }

                            productController.getBadStock(
                              product: product,
                              fromDate: productController.filterStartDate.value,
                              toDate: productController.filterEndDate.value,
                            );
                          },
                        ))
                    : Get.find<HomeController>().selectedWidget.value =
                        DateFilter(
                          from: "BadStockHistory",
                          product: product,
                          i: i,
                        function: (value) {
                          if (value is PickerDateRange) {
                            final DateTime rangeStartDate = value.startDate!;
                            final DateTime rangeEndDate = value.endDate!;
                            productController.filterStartDate.value =
                                rangeStartDate;
                            productController.filterEndDate.value =
                                rangeEndDate;
                          } else if (value is DateTime) {
                            final DateTime selectedDate = value;
                            productController.filterStartDate.value =
                                selectedDate;
                            productController.filterEndDate.value =
                                selectedDate;
                          }

                          productController.getBadStock(
                            product: product,
                            fromDate: productController.filterStartDate.value,
                            toDate: productController.filterEndDate.value,
                          );
                        },
                      );
              },
              icon: Icon(
                Icons.filter_alt,
                color: isSmallScreen(context) ? Colors.white : Colors.black,
              ))
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  "From ${'${DateFormat("yyy-MM-dd").format(productController.filterStartDate.value)} - ${DateFormat("yyy-MM-dd").format(productController.filterEndDate.value)}'}"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "TOTAL ${htmlPrice(productController.badstocks.fold(0, (previousValue, element) => previousValue + (element.quantity! * element.product!.buyingPrice!)))} /=",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            isSmallScreen(context)
                ? Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productController.badstocks.length,
                        itemBuilder: (context, index) {
                          BadStock badStock =
                              productController.badstocks.elementAt(index);

                          return productBadStockHistory(badStock);
                        }),
                  )
                : Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 5)
                        .copyWith(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.grey),
                      child: DataTable(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        columnSpacing: 30.0,
                        columns: const [
                          DataColumn(
                              label:
                                  Text('Product', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Quantity',
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Buying Price',
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Selling Price',
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Date', textAlign: TextAlign.center)),
                        ],
                        rows: List.generate(
                            productController.badstocks.length, (index) {
                          BadStock badStock = productController.badstocks.elementAt(index);

                          final p = badStock.product?.name;
                          final y = badStock.quantity;
                          final h = badStock.product?.buyingPrice;
                          final z = badStock.product?.selling;
                          final w = badStock.createdAt;

                          return DataRow(cells: [
                            DataCell(Text(p.toString())),
                            DataCell(Text(y.toString())),
                            DataCell(Text(h.toString())),
                            DataCell(Text(z.toString())),
                            DataCell(
                                Text(DateFormat("yyyy-dd-MMM ").format(w!))),
                          ]);
                        }),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}
