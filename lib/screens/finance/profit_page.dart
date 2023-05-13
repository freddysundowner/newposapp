import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
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
    var startDate = converTimeToMonth()["startDate"];
    var endDate = converTimeToMonth()["endDate"];
    salesController.getProfitTransaction(
        start: DateTime.parse(startDate),
        end: DateTime.parse(endDate),
        type: "finance",
        shopId: shopController.currentShop.value?.id);
  }

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expensesController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          var startDate = converTimeToMonth()["startDate"];
          var endDate = converTimeToMonth()["endDate"];
          salesController.getProfitTransaction(
              start: startDate,
              end: endDate,
              type: "finance",
              shopId: shopController.currentShop.value?.id);
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
          var startDate = converTimeToMonth()["startDate"];
          var endDate = converTimeToMonth()["endDate"];
          salesController.getProfitTransaction(
              start: startDate,
              end: endDate,
              type: "finance",
              shopId: shopController.currentShop.value);
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: majorTitle(title: "Profit", color: Colors.black, size: 16.0),
      actions: [
        InkWell(
            onTap: () {
              showDatePickers(
                  context: context,
                  function: () {
                    salesController.getProfitTransaction(
                        start: expensesController.startdate.value,
                        end: expensesController.enddate.value,
                        type: "finance",
                        shopId: shopController.currentShop.value?.id);
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Choose Date Range",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                ],
              ),
            ))
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
                          "${shopController.currentShop.value?.currency} ${salesController.profitModel.value!.sales ?? "0"}",
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
                        "${shopController.currentShop.value?.currency} ${salesController.profitModel.value?.profitOnSales ?? "0"}",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                          "${shopController.currentShop.value?.currency} ${salesController.profitModel.value?.badStockValue ?? "0"}",
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
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
                          "${shopController.currentShop.value?.currency} ${salesController.profitModel.value?.totalExpense ?? "0"}",
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
