import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pointify/screens/finance/finance_page.dart';
import 'package:pointify/screens/product/tabs/receipts_sales.dart';
import 'package:pointify/widgets/months_filter.dart';

import '../../../Real/schema.dart';
import '../../../controllers/sales_controller.dart';
import '../../../functions/functions.dart';
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
    return Obx(() {
      return MediaQuery.of(context).size.width > 600
          ? Column(
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
                            label:
                                Text('Quantity', textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Buying Price',
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Selling Price',
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Date', textAlign: TextAlign.center)),
                      ],
                      rows: List.generate(salesController.salesHistory.length,
                          (index) {
                        InvoiceItem productBody =
                            salesController.salesHistory.elementAt(index);
                        final y = productBody.product!.name;
                        final x = productBody.itemCount;
                        final w = productBody.product!.buyingPrice;
                        final z = productBody.product!.sellingPrice![0];
                        final a = productBody.createdAt;

                        return DataRow(cells: [
                          DataCell(Container(width: 75, child: Text(y!))),
                          DataCell(
                              Container(width: 75, child: Text(x.toString()))),
                          DataCell(
                              Container(width: 75, child: Text(w.toString()))),
                          DataCell(
                              Container(width: 75, child: Text(z.toString()))),
                          DataCell(Container(
                              width: 75,
                              child: Text(DateFormat("yyyy-dd-MM hh:mm a")
                                  .format(a!)))),
                        ]);
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 30)
              ],
            )
          : Column(
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
                          Text(
                              "SALES HISTORY ${salesController.currentYear.value}"),
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
                          print("n");
                          Get.to(() => PdfPreviewPage(
                              widget: ProductMonthlyReport(
                                  salesController.productSales,
                                  product: product),
                              type: "Invoice"));
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
                          product: product,
                          fromDate: firstday,
                          toDate: lastday);
                    }, year: salesController.currentYear.value);
                    Get.to(() => ProductReceiptsSales(
                          product: product,
                          i: i,
                        ));
                  }, counts: (month) {
                    return "${_getSalesCount(month)} sales";
                  },
                      totals: (month) =>
                          "${htmlPrice(_getSalesTotal(month))}/="),
                )
              ],
            );
    });
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
