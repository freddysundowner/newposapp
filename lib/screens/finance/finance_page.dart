import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/finance/product_comparison.dart';
import 'package:pointify/screens/finance/profit_page.dart';
import 'package:pointify/screens/home/home.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../controllers/sales_controller.dart';
import '../../functions/functions.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../home/home_page.dart';
import '../sales/all_sales.dart';
import 'expense_page.dart';
import 'graph_analysis.dart';

class FinancePage extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expenseController = Get.find<ExpenseController>();

  List operations = [
    {
      "title": "Today",
      "subtitle": "Gross & Net profits",
      "icon": Icons.today,
      "color": Colors.amber.shade100,
      "showsummary": false,
      "amount": "${Get.find<SalesController>().grossProfit}"
    },
    {
      "title": "Current Month",
      "subtitle": "Gross & Net profits",
      "icon": Icons.calendar_month,
      "color": Colors.amber.shade100,
      "showsummary": false,
      "amount": "${Get.find<SalesController>().grossProfit}"
    },
    {
      "title": "Monthly Profit & Expenses",
      "subtitle": "Monthly profits versus expenses",
      "icon": Icons.calendar_month,
      "color": Colors.blue.shade100,
      "showsummary": false,
      "amount": "${Get.find<SalesController>().grossProfit}"
    },
    {
      "title": "Graphical Analysis",
      "subtitle": "Analyze shop performance in a graph",
      "icon": Icons.show_chart,
      "color": Colors.purple.shade100,
      "showsummary": false,
      "amount": Get.find<ExpenseController>().totalExpenses.value
    },
    {
      "title": "Products Movement",
      "subtitle": "view fast and slow moving products",
      "icon": Icons.sell_rounded,
      "color": Colors.blue.shade100,
      "showsummary": false,
      "amount": "${Get.find<SalesController>().totalSalesByDate.value}"
    },
  ];

  FinancePage({Key? key}) : super(key: key) {
    salesController.getFinanceSummary(
      fromDate: DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now())),
      toDate: DateTime.parse(DateFormat("yyy-MM-dd")
          .format(DateTime.now().add(const Duration(days: 1)))),
    );
  }

  String _range = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
          ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';

      if (args.value.startDate != null && args.value.endDate != null) {
        salesController.getProfitTransaction(
          fromDatee: DateFormat('yyy-MM-dd').format(args.value.startDate),
          toDatee: DateFormat('yyy-MM-dd')
              .format(args.value.endDate ?? args.value.startDate),
        );
        isSmallScreen(Get.context)
            ? Get.to(() => ProfitPage(headline: "from\n$_range"))
            : Get.find<HomeController>().selectedWidget.value =
                ProfitPage(headline: "from\n$_range");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Helper(
      widget: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  monthViewSettings: const DateRangePickerMonthViewSettings(),
                  headerStyle: DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                          fontSize: 18)),
                  onSubmit: (v) {
                    print(v);
                  }),
              isSmallScreen(context)
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: operations.length,
                      itemBuilder: (context, index) {
                        return financeCards(
                            title: operations[index]["title"],
                            subtitle: operations[index]["subtitle"],
                            icon: operations[index]["icon"],
                            onPresssed: () {
                              switch (operations[index]["title"]) {
                                case "Today":
                                  {
                                    salesController.getProfitTransaction(
                                      fromDate: DateTime.parse(
                                          DateFormat("yyy-MM-dd")
                                              .format(DateTime.now())),
                                      toDate: DateTime.parse(
                                          DateFormat("yyy-MM-dd").format(
                                              DateTime.now().add(
                                                  const Duration(days: 1)))),
                                    );
                                    isSmallScreen(context)
                                        ? Get.to(
                                            () => ProfitPage(headline: "Today"))
                                        : Get.find<HomeController>()
                                                .selectedWidget
                                                .value =
                                            ProfitPage(headline: "Today");
                                  }
                                  break;

                                case "Current Month":
                                  {
                                    DateTime now = DateTime.now();
                                    var lastday =
                                        DateTime(now.year, now.month + 1, 0);

                                    final noww = DateTime.now();

                                    var firstday =
                                        DateTime(noww.year, noww.month, 1);
                                    salesController.getProfitTransaction(
                                      fromDate: firstday,
                                      toDate: lastday,
                                    );
                                    isSmallScreen(context)
                                        ? Get.to(() => ProfitPage(
                                              headline:
                                                  '\n${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}',
                                            ))
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = ProfitPage(
                                            headline:
                                                '\n${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}',
                                          );
                                  }
                                  break;
                                case "Monthly Profit & Expenses":
                                  {
                                    isSmallScreen(context)
                                        ? Get.to(() => MonthFilter())
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = MonthFilter();
                                  }
                                  break;

                                case "Graphical Analysis":
                                  {
                                    isSmallScreen(context)
                                        ? Get.to(() => GraphAnalysis())
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = GraphAnalysis();
                                  }
                                  break;
                                case "Products Movement":
                                  {
                                    salesController.selectedMonth.value =
                                        DateTime.now().month;
                                    salesController.currentYear.value =
                                        DateTime.now().year;
                                    isSmallScreen(context)
                                        ? Get.to(() => ProductAnalysis())
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = ProductAnalysis();
                                  }
                                  break;
                              }
                            },
                            color: operations[index]["color"],
                            amount: operations[index]["amount"]);
                      })
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio:
                              MediaQuery.of(context).size.width > 1100
                                  ? 1.3
                                  : MediaQuery.of(context).size.width > 900
                                      ? 1.0
                                      : 0.7,
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      shrinkWrap: true,
                      itemCount: operations.length,
                      itemBuilder: (context, index) {
                        return financeCards(
                            title: operations[index]["title"],
                            subtitle: operations[index]["subtitle"],
                            icon: operations[index]["icon"],
                            onPresssed: () {
                              switch (operations[index]["title"]) {
                                case "Today":
                                  {
                                    salesController.getProfitTransaction(
                                      fromDate: DateTime.parse(
                                          DateFormat("yyy-MM-dd")
                                              .format(DateTime.now())),
                                      toDate: DateTime.parse(
                                          DateFormat("yyy-MM-dd").format(
                                              DateTime.now().add(
                                                  const Duration(days: 1)))),
                                    );
                                    isSmallScreen(context)
                                        ? Get.to(
                                            () => ProfitPage(headline: "Today"))
                                        : Get.find<HomeController>()
                                                .selectedWidget
                                                .value =
                                            ProfitPage(headline: "Today");
                                  }
                                  break;

                                case "Current Month":
                                  {
                                    DateTime now = DateTime.now();
                                    var lastday =
                                        DateTime(now.year, now.month + 1, 0);

                                    final noww = DateTime.now();

                                    var firstday =
                                        DateTime(noww.year, noww.month, 1);
                                    salesController.getProfitTransaction(
                                      fromDate: firstday,
                                      toDate: lastday,
                                    );
                                    isSmallScreen(context)
                                        ? Get.to(() => ProfitPage(
                                              headline:
                                                  '\n${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}',
                                            ))
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = ProfitPage(
                                            headline:
                                                '\n${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}',
                                          );
                                  }
                                  break;
                                case "Monthly Profit & Expenses":
                                  {
                                    isSmallScreen(context)
                                        ? Get.to(() => MonthFilter())
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = MonthFilter();
                                  }
                                  break;

                                case "Graphical Analysis":
                                  {
                                    isSmallScreen(context)
                                        ? Get.to(() => GraphAnalysis())
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = GraphAnalysis();
                                  }
                                  break;
                                case "Products Movement":
                                  {
                                    salesController.selectedMonth.value =
                                        DateTime.now().month;
                                    salesController.currentYear.value =
                                        DateTime.now().year;
                                    isSmallScreen(context)
                                        ? Get.to(() => ProductAnalysis())
                                        : Get.find<HomeController>()
                                            .selectedWidget
                                            .value = ProductAnalysis();
                                  }
                                  break;
                              }
                            },
                            color: operations[index]["color"],
                            amount: operations[index]["amount"]);
                      }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        width: 200,
        height: isSmallScreen(context) ? 60 : 0,
        child: InkWell(
          onTap: () {
            Get.to(() => ExpensePage());
          },
          child: Container(
              margin: const EdgeInsets.only(
                  left: 60, right: 60, bottom: 10, top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.mainColor),
              child: const Center(
                  child: Text(
                "Add Expense",
                style: TextStyle(color: Colors.white),
              ))),
        ),
      ),
      floatButton: Container(),
      appBar: appBar(context),
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
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: majorTitle(
          title: "Profit & expenses", color: Colors.black, size: 16.0),
      actions: [
        if (!isSmallScreen(context))
          InkWell(
            onTap: () {
              Get.find<HomeController>().selectedWidget.value = ExpensePage();
            },
            child: Container(
                height: kToolbarHeight * 0.4,
                margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.mainColor),
                child: const Center(
                    child: Text(
                  "Add Expense",
                  style: TextStyle(color: Colors.white),
                ))),
          )
      ],
    );
  }

  Widget financeCards(
      {required title,
      required subtitle,
      required icon,
      bool? showsummary = true,
      required onPresssed,
      required Color color,
      required amount}) {
    return InkWell(
      onTap: () {
        onPresssed();
      },
      child: Container(
        margin: EdgeInsets.only(
            top: 10, right: isSmallScreen(Get.context) ? 0 : 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: isSmallScreen(Get.context)
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          mainAxisAlignment: isSmallScreen(Get.context)
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            isSmallScreen(Get.context)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(child: Icon(icon)),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          majorTitle(
                              title: title,
                              color: Colors.black,
                              size: isSmallScreen(Get.context) ? 16.0 : 12.0),
                          const SizedBox(height: 5),
                          minorTitle(title: subtitle, color: Colors.grey)
                        ],
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        child: Center(child: Icon(icon)),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          majorTitle(
                              title: title,
                              color: Colors.black,
                              size: isSmallScreen(Get.context) ? 16.0 : 12.0),
                          const SizedBox(height: 5),
                          minorTitle(title: subtitle, color: Colors.grey)
                        ],
                      )
                    ],
                  ),
            const SizedBox(
              height: 10,
            ),
            if (showsummary == true)
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

class MonthFilter extends StatelessWidget {
  MonthFilter({Key? key}) : super(key: key);
  List<Map<String, dynamic>> monhts = [
    {"month": "January"},
    {"month": "February"},
    {"month": "March"},
    {"month": "April"},
    {"month": "May"},
    {"month": "June"},
    {"month": "July"},
    {"month": "August"},
    {"month": "September"},
    {"month": "October"},
    {"month": "November"},
    {"month": "December"},
  ];
  SalesController salesController = Get.find<SalesController>();

  List<int> getYears(int year) {
    int currentYear = DateTime.now().year;

    List<int> yearsTilPresent = [];

    while (year <= currentYear) {
      yearsTilPresent.add(year);
      year++;
    }

    return yearsTilPresent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pick a month',
          style: TextStyle(
              color: isSmallScreen(context) ? Colors.white : Colors.black),
        ),
        elevation: 0.1,
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        leading: IconButton(
            onPressed: () {
              if (isSmallScreen(context)) {
                Get.back();
              } else {
                Get.find<HomeController>().selectedWidget.value = FinancePage();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isSmallScreen(context) ? Colors.white : Colors.black,
            )),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: getYears(2019).length,
                          itemBuilder: (c, i) {
                            var year = getYears(2019)[i];
                            return InkWell(
                              onTap: () {
                                salesController.currentYear.value = year;
                                Get.back();
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      year.toString().capitalize!,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  const Divider()
                                ],
                              ),
                            );
                          }),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  Obx(() => Text(salesController.currentYear.value.toString())),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
            itemCount: monhts.length,
            itemBuilder: (c, i) {
              var month = monhts[i];
              return InkWell(
                onTap: () {
                  DateTime now =
                      DateTime(salesController.currentYear.value, i + 1);
                  var lastday = DateTime(now.year, now.month + 1, 0);
                  final noww =
                      DateTime(salesController.currentYear.value, i + 1);
                  var firstday = DateTime(noww.year, noww.month, 1);

                  var d = DateFormat("yyy-MM-dd").format(
                      DateTime(salesController.currentYear.value, i + 1));

                  salesController.getProfitTransaction(
                    fromDate: firstday,
                    toDate: lastday,
                  );

                  isSmallScreen(context)
                      ? Get.to(() => ProfitPage(
                          headline:
                              "from\n${'${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}'}"))
                      : Get.find<HomeController>().selectedWidget.value =
                          ProfitPage(
                              headline:
                                  "from\n${'${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}'}");
                },
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        children: [
                          Text(month["month"].toString().capitalize!),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    const Divider()
                  ],
                ),
              );
            }),
      ),
    );
  }
}

financeChat(context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        color: AppColors.lightDeepPurple,
        borderRadius: BorderRadius.circular(10)),
    child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <LineSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
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
