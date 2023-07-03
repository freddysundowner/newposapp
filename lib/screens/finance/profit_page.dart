import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/expense_page.dart';
import 'package:pointify/screens/finance/finance_page.dart';
import 'package:pointify/screens/stock/badstocks.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/date_filter.dart';
import '../sales/all_sales.dart';

class ProfitPage extends StatelessWidget {
  String? headline;

  ProfitPage({Key? key, this.headline}) : super(key: key) {}

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expensesController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
          child: body(context),
        ),
      ),
      smallScreen: Helper(
        widget: Container(
          child: body(context),
        ),
        appBar: _appBar(context),
      ),
    );
  }

  AppBar _appBar(context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: AppColors.mainColor,
      elevation: 0.3,
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = FinancePage();
          } else {
            Get.back();
          }
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      actions: [
        InkWell(
            onTap: () async {
              Get.to(() => DateFilter(
                    function: (value) {
                      if (value is PickerDateRange) {
                        final DateTime rangeStartDate = value.startDate!;
                        final DateTime rangeEndDate = value.endDate!;
                        salesController.filterStartDate.value = rangeStartDate;
                        salesController.filterEndDate.value = rangeEndDate;
                      } else if (value is DateTime) {
                        final DateTime selectedDate = value;
                        salesController.filterStartDate.value = selectedDate;
                        salesController.filterEndDate.value = selectedDate;
                      }

                      salesController.getProfitTransaction(
                          fromDate: salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value);
                    },
                  ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: const Center(
                child: Row(
                  children: [
                    Text(
                      "Filter",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.filter_list_alt,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget body(context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            color: AppColors.mainColor,
            child: Column(
              children: [
                SizedBox(height: 30),
                Center(
                    child: Text(
                  "Net Profit $headline",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 5, left: 10, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white.withOpacity(0.2)),
                        child: Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.white),
                            const SizedBox(width: 10),
                            Text(
                              htmlPrice(salesController.grossProfit.value -
                                  expensesController.totalExpenses.value),
                              style: const TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.all(15.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      if (MediaQuery.of(context).size.width > 600) {
                        Get.find<HomeController>().selectedWidget.value =
                            AllSalesPage(page: "profitPage");
                      } else {
                        salesController.getSales(
                            fromDate: salesController.filterStartDate.value,
                            toDate: salesController.filterEndDate.value);
                        Get.to(AllSalesPage(
                          page: "profitPage",
                        ));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Total Sales",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Click To View Sales ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          htmlPrice(salesController.allSalesTotal.value),
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profit On Sales",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "(Gross Profit)",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        htmlPrice(salesController.grossProfit),
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Get.find<ProductController>().getBadStock(
                          shopId: shopController.currentShop.value!.id,
                          attendant: '',
                          product: null,
                          fromDate: DateTime.parse(
                              DateFormat("yyy-MM-dd").format(DateTime.now())),
                          toDate: DateTime.parse(DateFormat("yyy-MM-dd")
                              .format(DateTime.now().add(Duration(days: 1)))));

                      isSmallScreen(context)
                          ? Get.to(() => BadStockPage(
                                page: "profitspage",
                              ))
                          : Get.find<HomeController>().selectedWidget.value =
                              BadStockPage(
                              page: "profitspage",
                            );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bad Stock",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Total Bad Stock",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          htmlPrice(salesController.totalbadStock.value),
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      expensesController.getExpenseByDate(
                        fromDate: expensesController.filterStartDate.value,
                        toDate: expensesController.filterEnndStartDate.value,
                      );
                      isSmallScreen(context)
                          ? Get.to(() => ExpensePage())
                          : Get.find<HomeController>().selectedWidget.value =
                              ExpensePage();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Expenses",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Click To View All Expenses",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          htmlPrice(expensesController.totalExpenses.value),
                          style: const TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
          SizedBox(height: 25),
          Spacer(),
        ],
      );
    });
  }
}
