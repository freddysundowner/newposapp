import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/components/date_picker.dart';
import 'package:pointify/screens/finance/expense_page.dart';
import 'package:pointify/screens/finance/finance_page.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/dates.dart';
import '../../widgets/bigtext.dart';
import '../sales/all_sales_page.dart';

class ProfitPage extends StatelessWidget {
  ProfitPage({Key? key}) : super(key: key) {
    salesController.getProfitTransaction(
        fromDate: expensesController.startdate.value,
        toDate: expensesController.enddate.value);
  }

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expensesController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          salesController.getProfitTransaction(
              fromDate: expensesController.startdate.value,
              toDate: expensesController.enddate.value);
          return true;
        },
        child: ResponsiveWidget(
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
              padding: EdgeInsets.all(10),
              child: body(context),
            ),
            appBar: _appBar(context),
          ),
        ));
  }

  AppBar _appBar(context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0.3,
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = FinancePage();
          } else {
            Get.back();
          }
          salesController.getProfitTransaction(
              fromDate: expensesController.startdate.value,
              toDate: expensesController.enddate.value);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          majorTitle(title: "Profit", color: Colors.black, size: 16.0),
          Obx(
            () => Text(
              "${DateFormat("yyyy-MM-dd").format(expensesController.startdate.value)} - ${DateFormat("yyyy-MM-dd").format(expensesController.enddate.value)}",
              style: TextStyle(color: Colors.blue, fontSize: 13),
            ),
          )
        ],
      ),
      actions: [
        InkWell(
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                lastDate: DateTime(2079),
                firstDate: DateTime(2019),
              );
              salesController.getProfitTransaction(
                  fromDate: picked!.start, toDate: picked.end);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      "Filter",
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.filter_list_alt,
                      color: AppColors.mainColor,
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
                            fromDate: expensesController.startdate.value,
                            toDate: expensesController.enddate.value);
                        Get.to(AllSalesPage(
                          page: "profitPage",
                        ));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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
                    onTap: () {},
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
                      Get.find<HomeController>().selectedWidget.value =
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
