import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/finance/product_comparison.dart';
import 'package:pointify/screens/finance/profit_page.dart';
import 'package:pointify/screens/sales/create_sale.dart';
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

class SalesPage extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  ExpenseController expenseController = Get.find<ExpenseController>();

  SalesPage({Key? key}) : super(key: key) {
    // salesController.getFinanceSummary(
    //   fromDate: DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now())),
    //   toDate: DateTime.parse(DateFormat("yyy-MM-dd")
    //       .format(DateTime.now().add(Duration(days: 1)))),
    // );
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
            ? Get.to(() => ProfitPage(headline: "from\n$_range",   page: "salesPage",))
            : Get.find<HomeController>().selectedWidget.value =
            ProfitPage(headline: "from\n$_range",   page: "salesPage",);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Helper(
      widget: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
          BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      Obx(() {
                        return financeCards(
                            title: "Today",
                            subtitle: "view today sales",
                            showsummary: false,
                            onPresssed: () {
                              var fromDate = DateTime.parse(
                                  DateFormat("yyy-MM-dd")
                                      .format(DateTime.now()));
                              var toDate = DateTime.parse(
                                  DateFormat("yyy-MM-dd").format(DateTime.now()
                                      .add(const Duration(days: 1))));
                              salesController.filterStartDate.value = fromDate;
                              salesController.filterEndDate.value = toDate;
                              salesController.salesInitialIndex.value = 0;
                              salesController.getSalesByDate(
                                  fromDate: fromDate, toDate: toDate);

                              isSmallScreen(context)
                                  ? Get.to(() => AllSalesPage(page: ""))
                                  : Get.find<HomeController>()
                                  .selectedWidget
                                  .value = AllSalesPage(page: "salesPage");
                            },
                            color: Colors.amber.shade100,
                            icon: Icons.today,
                            amount: "${salesController.grossProfit}");
                      }),
                      Obx(() {
                        return financeCards(
                            title: "Current Month",
                            subtitle: "Gross & Net profits",
                            showsummary: false,
                            onPresssed: () {
                              DateTime now = DateTime.now();
                              var lastday =
                              DateTime(now.year, now.month + 1, 0);

                              final noww = DateTime.now();

                              var firstday = DateTime(noww.year, noww.month, 1);
                              salesController.filterEndDate.value = lastday;
                              salesController.filterStartDate.value = firstday;
                              salesController.getSalesByDate(
                                  fromDate: firstday, toDate: lastday);

                              isSmallScreen(context)
                                  ? Get.to(() => AllSalesPage(page: ""))
                                  : Get.find<HomeController>()
                                  .selectedWidget
                                  .value = AllSalesPage(page: "salesPage");
                            },
                            color: Colors.amber.shade100,
                            icon: Icons.calendar_month,
                            amount: "${salesController.grossProfit}");
                      }),
                      Obx(() {
                        return financeCards(
                            title: "Monthly Profit & Expenses",
                            subtitle: "Monthly profits versus expenses",
                            showsummary: false,
                            onPresssed: () {
                              // return Get.to(() => MonthFilter(from: "sales"));
                              isSmallScreen(context)
                                  ? Get.to(() => MonthFilter(from: "sales"))
                                  : Get.find<HomeController>()
                                  .selectedWidget
                                  .value = MonthFilter(from: "sales");
                            },
                            color: Colors.blue.shade100,
                            icon: Icons.menu,
                            amount: "${salesController.grossProfit}");
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        width: 200,
        height: isSmallScreen(context) ? 60 : 0,
        child: InkWell(
          onTap: () {
            Get.to(() => CreateSale());
          },
          child: Container(
              margin: const EdgeInsets.only(
                  left: 60, right: 60, bottom: 10, top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.mainColor),
              child: const Center(
                  child: Text(
                    "Add Sales",
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
      title:
      majorTitle(title: "Sales & Order", color: Colors.black, size: 16.0),
      actions: [
        // InkWell(
        //     onTap: () async {
        //       final picked = await showDateRangePicker(
        //         context: context,
        //         lastDate: DateTime(2079),
        //         firstDate: DateTime(2019),
        //       );
        //       salesController.filterStartDate.value = picked!.start;
        //       salesController.filterEnndStartDate.value = picked.end;
        //
        //       salesController.getFinanceSummary(
        //           fromDate: picked.start, toDate: picked.end);
        //     },
        //     child: Container(
        //       padding: EdgeInsets.symmetric(horizontal: 20),
        //       child: Center(
        //         child: Row(
        //           children: [
        //             Text(
        //               "Filter",
        //               style: TextStyle(
        //                   color: AppColors.mainColor,
        //                   fontWeight: FontWeight.bold),
        //             ),
        //             Icon(
        //               Icons.filter_list_alt,
        //               color: AppColors.mainColor,
        //               size: 20,
        //             )
        //           ],
        //         ),
        //       ),
        //     ))
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
            top: 10,
            right: isSmallScreen(Get.context) ? 0 : 15,
            left: isSmallScreen(Get.context) ? 0 : 15),
        padding: const EdgeInsets.all(10),
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
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(title: title, color: Colors.black, size: 16.0),
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
  String? from;

  MonthFilter({Key? key, this.from}) : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick a month"),
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

                  if (from == "sales") {
                    salesController.filterStartDate.value = firstday;
                    salesController.filterEndDate.value = lastday;
                    salesController.getSales(
                        fromDate: firstday, toDate: lastday);
                    isSmallScreen(context)
                        ? Get.to(() => AllSalesPage(page: ""))
                        : Get.find<HomeController>().selectedWidget.value =
                        AllSalesPage(page: "salesPage");
                  } else {
                    salesController.getProfitTransaction(
                      fromDate: firstday,
                      toDate: lastday,
                    );
                    isSmallScreen(context)
                        ? Get.to(() => ProfitPage(
                      page: "salesPage",
                        headline:
                        "from\n${'${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}'}"))
                        : Get.find<HomeController>().selectedWidget.value =
                        ProfitPage(
                            page: "salesPage",
                            headline:
                            "from\n${'${DateFormat("yyy-MM-dd").format(firstday)}-${DateFormat("yyy-MM-dd").format(lastday)}'}");
                  }
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
