import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Real/schema.dart';
import '../../../controllers/product_controller.dart';
import '../../../functions/functions.dart';
import '../../../pdfFiles/pdf/productmonthlypdf/monthlypreview.dart';
import '../../../pdfFiles/pdf/productmonthlypdf/product_monthly_report.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_filter.dart';
import '../../../widgets/bottom_widget_count_view.dart';
import '../../../widgets/months_filter.dart';
import '../components/product_history_card.dart';
import '../product_history.dart';

class ProductStockInHistory extends StatelessWidget {
  ProductController productController = Get.find<ProductController>();
  Product? product;
  ProductStockInHistory({Key? key, this.product});

  SalesController salesController = Get.find<SalesController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MediaQuery.of(context).size.width > 600
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  // Theme(
                  //   data: Theme.of(context)
                  //       .copyWith(dividerColor: Colors.grey),
                  //   child: Container(
                  //     width: double.infinity,
                  //     margin: const EdgeInsets.only(
                  //         right: 15, left: 15, bottom: 20),
                  //     child: DataTable(
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //         width: 1,
                  //         color: Colors.black,
                  //       )),
                  //       columnSpacing: 30.0,
                  //       columns: [
                  //         DataColumn(
                  //             label: Text('Product',
                  //                 textAlign: TextAlign.center)),
                  //         DataColumn(
                  //             label: Text('Quantity',
                  //                 textAlign: TextAlign.center)),
                  //         DataColumn(
                  //             label: Text('Buying Price',
                  //                 textAlign: TextAlign.center)),
                  //         DataColumn(
                  //             label: Text('Selling Price',
                  //                 textAlign: TextAlign.center)),
                  //         DataColumn(
                  //             label: Text('Date',
                  //                 textAlign: TextAlign.center)),
                  //       ],
                  //       rows: List.generate(
                  //           purchaseController.purchasedItems.length,
                  //           (index) {
                  //         ProductHistoryModel productBody =
                  //             ProductHistoryModel(ObjectId());
                  //         final y = productBody.product!.name;
                  //         final x = productBody.quantity;
                  //         final w = productBody.product!.buyingPrice;
                  //         final z = productBody.product!.sellingPrice[0];
                  //         final a = productBody.createdAt;
                  //
                  //         return DataRow(cells: [
                  //           DataCell(Container(width: 75, child: Text(y!))),
                  //           DataCell(Container(
                  //               width: 75, child: Text(x.toString()))),
                  //           DataCell(Container(
                  //               width: 75, child: Text(w.toString()))),
                  //           DataCell(Container(
                  //               width: 75, child: Text(z.toString()))),
                  //           DataCell(Container(
                  //               width: 75,
                  //               child: Text(
                  //                   DateFormat("dd-MM-yyyy").format(a!)))),
                  //         ]);
                  //       }),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 30)
                ],
              ),
            )
          : Column(
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
                          Text(
                              "STOCKINS HISTORY ${productController.currentYear.value}"),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            htmlPrice(productController.productInvoices.fold(
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
                          Get.to(() => MonthlyPreviewPage(
                              sales: monhts
                                  .map((e) => [
                                        e["month"],
                                        htmlPrice(getSalesTotal(e["month"],
                                            productController.productInvoices,
                                            type: "stockin")),
                                      ])
                                  .toList(),
                              type: "Product Stockin",
                              product: product,
                              title: "Monthly stocking for ${product!.name!}",
                              total: productController.productInvoices.fold(
                                  0,
                                  (previousValue, element) =>
                                      previousValue! + element.total!)));
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
                      productController.getProductPurchaseHistory(product,
                          fromDate: firstday, toDate: lastday);
                    }, year: productController.currentYear.value);
                    Get.to(() => ProductStockHistory(
                          product: product!,
                          i: i,
                        ));
                  }, counts: (month) {
                    return "${_getSalesCount(month)} sales";
                  },
                      totals: (month) =>
                          "${htmlPrice(_getSalesTotal(month))}/="),
                ),
              ],
            );
    });
  }

  _getSalesCount(String month) {
    return productController.productInvoices
        .where((p0) =>
            _getDate("MMMM", p0.createdAt!.millisecondsSinceEpoch) == month)
        .length;
  }

  _getSalesTotal(String month) {
    return productController.productInvoices
        .where((p0) =>
            _getDate("MMMM", p0.createdAt!.millisecondsSinceEpoch) == month)
        .fold(
            0,
            (previousValue, element) =>
                previousValue +
                (element.itemCount! * element.product!.buyingPrice!));
  }

  _getDate(String format, int date) {
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date));
  }
}

class ProductStockHistory extends StatelessWidget {
  Product product;
  int i;
  ProductStockHistory({Key? key, required this.product, required this.i})
      : super(key: key);
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            getYearlyRecords(product, function: (Product product,
                DateTime firstDayofYear, DateTime lastDayofYear) {
              productController.getProductPurchaseHistory(product,
                  fromDate: firstDayofYear, toDate: lastDayofYear);
            }, year: productController.currentYear.value);
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Stock-in",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              product.name!,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
        actions: [
          const Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
            size: 25,
          ),
          IconButton(
              onPressed: () async {
                Get.to(() => DateFilter(
                      function: (value) {
                        if (value is PickerDateRange) {
                          final DateTime rangeStartDate = value.startDate!;
                          final DateTime rangeEndDate = value.endDate!;
                          productController.filterStartDate.value =
                              rangeStartDate;
                          productController.filterEndDate.value = rangeEndDate;
                        } else if (value is DateTime) {
                          final DateTime selectedDate = value;
                          productController.filterStartDate.value =
                              selectedDate;
                          productController.filterEndDate.value = selectedDate;
                        }

                        productController.getProductPurchaseHistory(
                          product,
                          fromDate: productController.filterStartDate.value,
                          toDate: productController.filterEndDate.value,
                        );
                      },
                    ));
              },
              icon: const Icon(
                Icons.filter_alt,
                color: Colors.white,
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                  "From ${'${DateFormat("yyy-MM-dd").format(productController.filterStartDate.value)} - ${DateFormat("yyy-MM-dd").format(productController.filterEndDate.value)}'}"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "TOTAL ${htmlPrice(productController.productInvoices.fold(0, (previousValue, element) => previousValue + element.total!))} /=",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productController.productInvoices.length,
                  itemBuilder: (context, index) {
                    InvoiceItem productBody =
                        productController.productInvoices.elementAt(index);

                    return productPurchaseHistoryContainer(productBody);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
