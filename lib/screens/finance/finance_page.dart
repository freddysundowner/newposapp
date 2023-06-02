import 'package:flutter/material.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/finance/components/date_picker.dart';
import 'package:pointify/screens/finance/profit_page.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dates.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../home/home_page.dart';
import '../sales/all_sales_page.dart';
import 'expense_page.dart';

class FinancePage extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expenseController = Get.find<ExpenseController>();

  FinancePage({Key? key}) : super(key: key) {
    var startDate = converTimeToMonth()["startDate"];
    var endDate = converTimeToMonth()["endDate"];
    salesController.getProfitTransaction(
        start: DateTime.parse(startDate),
        end: DateTime.parse(endDate),
        type: "finance",
        shopId: shopController.currentShop.value?.id);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(context),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                majorTitle(
                    title: "Weekly Profit Trajectory",
                    color: Colors.black,
                    size: 16.0),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: financeChat(context),
                ),
                SizedBox(height: 20),
                majorTitle(
                    title: "Financial Operations",
                    color: Colors.black,
                    size: 16.0),
                SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: financeCards(
                                title: "Profits",
                                subtitle: "Gross & Net profits",
                                onPresssed: () {
                                  Get.find<HomeController>()
                                      .selectedWidget
                                      .value = ProfitPage();
                                },
                                color: Colors.amber.shade100,
                                icon: Icons.query_stats,
                                amount: salesController.profitModel.value ==
                                        null
                                    ? 0
                                    : "${salesController.profitModel.value?.grossProfit}"),
                          )),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: financeCards(
                            title: "Expenses",
                            subtitle: "Expenditure",
                            onPresssed: () {
                              Get.find<HomeController>().selectedWidget.value =
                                  ExpensePage();
                            },
                            color: Colors.purple.shade100,
                            icon: Icons.show_chart,
                            amount: salesController.profitModel.value == null
                                ? 0
                                : "${salesController.profitModel.value?.totalExpense}",
                          ),
                        );
                      }),
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.only(right: 18.0),
                          child: financeCards(
                            title: "Sales",
                            subtitle: "services",
                            onPresssed: () {
                              Get.find<HomeController>().selectedWidget.value =
                                  AllSalesPage(
                                page: "financePage",
                              );
                              salesController.getSales(onCredit: "");
                            },
                            color: Colors.blue.shade100,
                            icon: Icons.sell_rounded,
                            amount: salesController.profitModel.value == null
                                ? 0
                                : "${salesController.profitModel.value?.sales}",
                          ),
                        );
                      }),
                      InkWell(
                        onTap: () {
                          Get.find<HomeController>().selectedWidget.value =
                              CashFlowManager();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 18),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                        child: Icon(Icons.margin_outlined)),
                                    decoration: BoxDecoration(
                                        color: Colors.amberAccent,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      majorTitle(
                                          title: "Cashflow Manager",
                                          color: Colors.black,
                                          size: 16.0),
                                      SizedBox(height: 5),
                                      minorTitle(
                                          title: "Track finance",
                                          color: Colors.grey)
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      smallScreen: Helper(
        widget: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                majorTitle(
                    title: "Weekly Profit Trajectory",
                    color: Colors.black,
                    size: 16.0),
                SizedBox(height: 10),
                financeChat(context),
                SizedBox(height: 10),
                majorTitle(
                    title: "Financial Operations",
                    color: Colors.black,
                    size: 16.0),
                SizedBox(height: 10),
                Obx(() {
                  return financeCards(
                      title: "Profits",
                      subtitle: "Gross & Net profits",
                      onPresssed: () {
                        Get.to(() => ProfitPage());
                      },
                      color: Colors.amber.shade100,
                      icon: Icons.query_stats,
                      amount: salesController.profitModel.value == null
                          ? 0
                          : "${salesController.profitModel.value?.grossProfit}");
                }),
                Obx(() {
                  return financeCards(
                    title: "Expenses",
                    subtitle: "Expenditure",
                    onPresssed: () {
                      Get.to(() => ExpensePage());
                    },
                    color: Colors.purple.shade100,
                    icon: Icons.show_chart,
                    amount: salesController.profitModel.value == null
                        ? 0
                        : "${salesController.profitModel.value?.totalExpense}",
                  );
                }),
                Obx(() {
                  return financeCards(
                    title: "Sales",
                    subtitle: "services",
                    onPresssed: () {
                      salesController.salesInitialIndex.value = 0;
                      salesController.getSales();

                      Get.to(() => AllSalesPage(
                            page: "financePage",
                          ));
                    },
                    color: Colors.blue.shade100,
                    icon: Icons.sell_rounded,
                    amount: salesController.profitModel.value == null
                        ? 0
                        : "${salesController.profitModel.value?.sales}",
                  );
                }),
                InkWell(
                  onTap: () {
                    Get.to(() => CashFlowManager());
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: Center(child: Icon(Icons.margin_outlined)),
                              decoration: BoxDecoration(
                                  color: Colors.amberAccent,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                majorTitle(
                                    title: "Cashflow Manager",
                                    color: Colors.black,
                                    size: 16.0),
                                SizedBox(height: 5),
                                minorTitle(
                                    title: "Track finance", color: Colors.grey)
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: appBar(context),
      ),
    );
  }

  AppBar appBar(context) {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0.3,
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = HomePage();
          } else {
            Get.back();
          }
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: majorTitle(title: "Financial", color: Colors.black, size: 16.0),
      actions: [
        InkWell(
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                lastDate: DateTime(2079),
                firstDate: DateTime(2019),
              );
              expenseController.startdate.value = picked!.start;
              expenseController.enddate.value = picked.end;

              salesController.getProfitTransaction(
                  start: expenseController.startdate.value,
                  end: expenseController.enddate.value,
                  type: "finance",
                  shopId: shopController.currentShop.value?.id);
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
            ))
      ],
    );
  }

  Widget financeCards(
      {required title,
      required subtitle,
      required icon,
      required onPresssed,
      required Color color,
      required amount}) {
    return InkWell(
      onTap: () {
        onPresssed();
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  child: Center(child: Icon(icon)),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(20)),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(title: title, color: Colors.black, size: 16.0),
                    SizedBox(height: 5),
                    minorTitle(title: subtitle, color: Colors.grey)
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            normalText(
                title:
                    " ${title} summary: ${shopController.currentShop.value?.currency}.${amount} ",
                color: Colors.black,
                size: 14.0)
          ],
        ),
      ),
    );
  }
}

financeChat(context) {
  return Container(
    // padding: EdgeInsets.fromLTRB(10,5,10,5),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: AppColors.lightDeepPurple,
        borderRadius: BorderRadius.circular(10)),
    child: SfCartesianChart(
        // Initialize category axis
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
              // Bind data source
              dataSource: <SalesData>[
                SalesData('Jan', 0),
                SalesData('Feb', 2),
                SalesData('Mar', 0),
                SalesData('Apr', 32),
                SalesData('May', 40),
                SalesData('Jun', 35),
                SalesData('Jul', 28),
                SalesData('Aug', 34),
                SalesData('Sep', 32),
                SalesData('Oct', 40),
                SalesData('Nov', 34),
                SalesData('Dec', 32),
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales),
          LineSeries<SalesData, String>(

              // Bind data source
              dataSource: <SalesData>[
                SalesData('Jan', 25),
                SalesData('Feb', 27),
                SalesData('Mar', 32),
                SalesData('Apr', 36),
                SalesData('May', 36),
                SalesData('Jun', 40),
                SalesData('Jul', 42),
                SalesData('Aug', 34),
                SalesData('Sep', 32),
                SalesData('Oct', 40),
                SalesData('Nov', 34),
                SalesData('Dec', 32),
              ],
              xValueMapper: (SalesData sales, _) => sales.year,
              yValueMapper: (SalesData sales, _) => sales.sales)
        ]),
  );
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
