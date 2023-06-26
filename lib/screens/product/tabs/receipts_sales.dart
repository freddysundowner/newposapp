import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../Real/schema.dart';
import '../../../controllers/sales_controller.dart';
import '../../../functions/functions.dart';
import '../../../utils/colors.dart';
import '../../../utils/date_filter.dart';
import '../../../widgets/showReceiptManageModal.dart';
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
        leading: IconButton(
          onPressed: () {
            getYearlyRecords(product, function:
                (Product p, DateTime firstDayofYear, DateTime lastDayofYear) {
              salesController.getSalesByProductId(
                  product: product,
                  fromDate: firstDayofYear,
                  toDate: lastDayofYear);
            }, year: salesController.currentYear.value);
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sales",
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
                  "From ${'${DateFormat("yyy-MM-dd").format(salesController.filterStartDate.value)} - ${DateFormat("yyy-MM-dd").format(salesController.filterEndDate.value)}'}"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "TOTAL ${htmlPrice(salesController.productSales.fold(0, (previousValue, element) => previousValue + element.total!))} /=",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Expanded(
              child: Column(
                children: [
                  salesController.productSales.isEmpty
                      ? const Center(
                          child: Text("There are no iems to display"),
                        )
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: salesController.productSales.length,
                              itemBuilder: (context, index) {
                                ReceiptItem receiptItem = salesController
                                    .productSales
                                    .elementAt(index);
                                return productHistoryContainer(receiptItem);
                              }),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productHistoryContainer(ReceiptItem receiptItem) {
    return InkWell(
      onTap: () {
        if (checkPermission(category: "sales", permission: "manage")) {
          showReceiptManageModal(Get.context!, receiptItem);
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
              SizedBox(
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
                  if (receiptItem.quantity == 0)
                    Text(
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
              Spacer(),
              if (checkPermission(category: "sales", permission: "manage"))
                Icon(
                  Icons.more_vert_rounded,
                )
            ],
          )),
    );
  }
}
