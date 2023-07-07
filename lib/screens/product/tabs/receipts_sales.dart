import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/tabs/product_sales.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Real/schema.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/sales_controller.dart';
import '../../../functions/functions.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_filter.dart';
import '../../../widgets/showReceiptManageModal.dart';
import '../../../widgets/tab_view.dart';
import '../components/product_history_table.dart';
import '../product_history.dart';

class ProductReceiptsSales extends StatelessWidget {
  Product product;
  int i;

  ProductReceiptsSales({Key? key, required this.product, required this.i})
      : super(key: key);

  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        elevation: 0.1,
        leading: IconButton(
          onPressed: () {
            getYearlyRecords(product, function:
                (Product p, DateTime firstDayofYear, DateTime lastDayofYear) {
              salesController.getSalesByProductId(
                  product: product,
                  fromDate: firstDayofYear,
                  toDate: lastDayofYear);
            }, year: salesController.currentYear.value);
            isSmallScreen(context)
                ? Get.back()
                : Get.find<HomeController>().selectedWidget.value =
                    ProductHistory(
                    product: product,
                  );
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: isSmallScreen(context) ? Colors.white : Colors.black,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sales",
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
                Get.to(() => DateFilter(
                      function: (value) {
                        if (value is PickerDateRange) {
                          final DateTime rangeStartDate = value.startDate!;
                          final DateTime rangeEndDate = value.endDate!;
                          salesController.filterStartDate.value =
                              rangeStartDate;
                          salesController.filterEndDate.value = rangeEndDate;
                        } else if (value is DateTime) {
                          final DateTime selectedDate = value;
                          salesController.filterStartDate.value = selectedDate;
                          salesController.filterEndDate.value = selectedDate;
                        }

                        salesController.getSalesByProductId(
                            fromDate: salesController.filterStartDate.value,
                            toDate: salesController.filterEndDate.value,
                            product: product);
                        salesController.getReturns(
                            product: product,
                            fromDate: salesController.filterStartDate.value,
                            toDate: salesController.filterEndDate.value,
                            type: "return");
                      },
                    ));
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
                  "From ${'${DateFormat("yyy-MM-dd").format(salesController.filterStartDate.value)} - ${DateFormat("yyy-MM-dd").format(salesController.filterEndDate.value)}'}"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            Expanded(
              child: DefaultTabController(
                  initialIndex: 0,
                  length: 2,
                  child: Builder(builder: (context) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TabBar(
                            controller: DefaultTabController.of(context),
                            onTap: (index) {
                              if (index == 0) {
                                salesController.getSalesByProductId(
                                    fromDate:
                                        salesController.filterStartDate.value,
                                    toDate: salesController.filterEndDate.value,
                                    product: product);
                              }
                              if (index == 1) {
                                salesController.getReturns(
                                    product: product,
                                    fromDate:
                                        salesController.filterStartDate.value,
                                    toDate: salesController.filterEndDate.value,
                                    type: "return");
                              }
                            },
                            tabs: [
                              Tab(
                                child: Obx(() => tabView(
                                    title: "Sales",
                                    subtitle: htmlPrice(
                                        salesController.productSales.fold(
                                            0,
                                            (previousValue, element) =>
                                                previousValue +
                                                element.total!)))),
                              ),
                              Tab(
                                  child: tabView(
                                      title: "Returns",
                                      subtitle: htmlPrice(
                                          salesController.allSalesReturns.fold(
                                              0,
                                              (previousValue, element) =>
                                                  previousValue +
                                                  element.total!)))),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: TabBarView(
                                  controller: DefaultTabController.of(context),
                                  children: [
                                    salesController.productSales.isEmpty
                                        ? const Center(
                                            child: Text(
                                                "There are no iems to display"),
                                          )
                                        : Obx(
                                            () {
                                              return !isSmallScreen(context)
                                                  ? productHistoryTable(
                                                      context: context,
                                                      items: salesController
                                                          .productSales,
                                                      showAction: true,
                                                      product: product)
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: salesController
                                                          .productSales.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        ReceiptItem
                                                            receiptItem =
                                                            salesController
                                                                .productSales
                                                                .elementAt(
                                                                    index);
                                                        return productHistoryContainer(
                                                            receiptItem);
                                                      });
                                            },
                                          ),
                                    salesController.allSalesReturns.isEmpty
                                        ? const Center(
                                            child: Text(
                                                "There are no iems to display"),
                                          )
                                        : Obx(() {
                                            return !isSmallScreen(context)
                                                ? productHistoryTable(
                                                    context: context,
                                                    items: salesController
                                                        .allSalesReturns,
                                                    showAction: false,
                                                    product: product)
                                                : ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: salesController
                                                        .allSalesReturns.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      ReceiptItem receiptItem =
                                                          salesController
                                                              .allSalesReturns
                                                              .elementAt(index);
                                                      return productHistoryContainer(
                                                          receiptItem);
                                                    });
                                          }),
                                  ]),
                            ),
                          )
                        ]);
                  })),
            ),
          ],
        ),
      ),
    );
  }

  Widget productHistoryContainer(ReceiptItem receiptItem) {
    return InkWell(
      onTap: () {
        if (checkPermission(category: "sales", permission: "manage") &&
            receiptItem.type != "return") {
          showReceiptManageModal(Get.context!, receiptItem, product);
        }
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ))),
          child: Row(
            children: [
              if (receiptItem.type == "return")
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.red),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.keyboard_return,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              if (receiptItem.type != "return")
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: AppColors.mainColor),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${receiptItem.product!.name}".capitalize!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                  if (receiptItem.type == "return")
                    const Text(
                      "item returned",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  if (receiptItem.quantity! > 0)
                    Text('Qty ${receiptItem.quantity} @ ${receiptItem.price}'),
                  if (receiptItem.createdAt != null)
                    Text(
                        '${DateFormat("MMM dd, yyyy, hh:m a").format(receiptItem.createdAt!)} '),
                ],
              ),
              const Spacer(),
              if (checkPermission(category: "sales", permission: "manage"))
                const Icon(
                  Icons.more_vert_rounded,
                )
            ],
          )),
    );
  }
}
