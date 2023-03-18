import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/finance/components/date_picker.dart';
import 'package:flutterpos/screens/finance/expense_page.dart';
import 'package:flutterpos/screens/finance/finance_page.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';

import '../../controllers/expense_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/dates.dart';
import '../../widgets/bigtext.dart';
import '../sales/all_sales_page.dart';

class ProfitPage extends StatelessWidget {
  ProfitPage({Key? key}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expensesController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    var startDate = converTimeToMonth()["startDate"];
    var endDate = converTimeToMonth()["endDate"];
    // salesController.getProfitTransaction(
    //     start: startDate,
    //     end: endDate,
    //     type: "finance",
    //     shopId: shopController.currentShop.value?.id);

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
              showDatePickers(context: context, function: () {});
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        // cashFlowController.transactions.value==null?0:cashFlowController.transactions.value!.wallet!.length==0?0:cashFlowController.transactions.value?.wallet![0].totalAmount
                        "0",
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
                      "0",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    // Get.to(BadStockUI());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
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
                        "0",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 15),
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
                        "0",
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 25),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: Container(
                //     padding: EdgeInsets.all(10),
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(50),
                //       border: Border.all(color: AppColors.mainColor,width: 3)
                //     ),
                //     child: majorTitle(title: "Related Expenses", color: AppColors.mainColor, size: 12.0),
                //   ),
                // ),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
        SizedBox(height: 25),
        Spacer(),
      ],
    );
  }
}
