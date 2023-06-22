import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Real/schema.dart';
import '../../../controllers/product_controller.dart';
import '../../../functions/functions.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_filter.dart';
import '../../../widgets/months_filter.dart';
import '../components/product_history_card.dart';

class ProductBadStcokHistory extends StatelessWidget {
  Product? product;
  ProductController productController = Get.find<ProductController>();

  ProductBadStcokHistory({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return MediaQuery.of(context).size.width > 600
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.grey),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(right: 15, left: 15, bottom: 20),
                      child: DataTable(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        columnSpacing: 30.0,
                        columns: [
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
                        rows: List.generate(productController.badstocks.length,
                            (index) {
                          ProductHistoryModel productBody =
                              ProductHistoryModel(ObjectId());
                          final y = productBody.product!.name;
                          final x = productBody.quantity;
                          final w = productBody.product!.buyingPrice;
                          final z = productBody.product!.sellingPrice![0];
                          final a = productBody.createdAt;

                          return DataRow(cells: [
                            DataCell(Container(width: 75, child: Text(y!))),
                            DataCell(Container(
                                width: 75, child: Text(x.toString()))),
                            DataCell(Container(
                                width: 75, child: Text(w.toString()))),
                            DataCell(Container(
                                width: 75, child: Text(z.toString()))),
                            DataCell(Container(
                                width: 75,
                                child:
                                    Text(DateFormat("dd-MM-yyyy").format(a!)))),
                          ]);
                        }),
                      ),
                    ),
                  ),
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
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.mainColor),
                        child: const Icon(
                          Icons.download_rounded,
                          color: Colors.white,
                          size: 15,
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
                          product: product,
                          fromDate: firstday,
                          toDate: lastday);
                    }, year: productController.currentYear.value);
                    Get.to(() => BadStockHistory(
                          product: product!,
                          i: i,
                        ));
                  }, counts: (month) {
                    return "${_getSalesCount(month)} Entries";
                  },
                      totals: (month) =>
                          "${htmlPrice(_getSalesTotal(month))}/="),
                ),
              ],
            );
    });
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
        leading: IconButton(
          onPressed: () {
            getYearlyRecords(product, function: (Product product,
                DateTime firstDayofYear, DateTime lastDayofYear) {
              productController.getBadStock(
                  product: product,
                  fromDate: firstDayofYear,
                  toDate: lastDayofYear);
            }, year: productController.currentYear.value);
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bad stock",
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

                        productController.getBadStock(
                          product: product,
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
      // bottomNavigationBar: bottomWidgetCountView(
      //     count: productController.productInvoices.length.toString(),
      //     qty: productController.productInvoices
      //         .fold(
      //             0,
      //             (previousValue, element) =>
      //                 previousValue + element.itemCount!)
      //         .toString(),
      //     onCrdit: htmlPrice(productController.productInvoices.fold(
      //         0,
      //         (previousValue, element) =>
      //             previousValue + element.invoice!.balance!)),
      //     cash: htmlPrice(productController.productInvoices.fold(
      //         0,
      //         (previousValue, element) =>
      //             previousValue + element.invoice!.total!))),
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
                "TOTAL ${htmlPrice(productController.badstocks.fold(0, (previousValue, element) => previousValue + (element.quantity! * element.product!.buyingPrice!)))} /=",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productController.badstocks.length,
                  itemBuilder: (context, index) {
                    BadStock badStock =
                        productController.badstocks.elementAt(index);

                    return productBadStockHistory(badStock);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
