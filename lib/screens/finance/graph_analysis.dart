import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import '../../controllers/home_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../responsive/responsiveness.dart';
import '../../utils/colors.dart';
import 'financial_page.dart';


class GraphAnalysis extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  GraphAnalysis({Key? key}) : super(key: key);

  @override
  _GraphAnalysisState createState() => _GraphAnalysisState();
}

class _GraphAnalysisState extends State<GraphAnalysis> {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

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
    salesController.getGraphSales();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profit Analysis',
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
                Get.find<HomeController>().selectedWidget.value = FinancialPage();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isSmallScreen(context) ? Colors.white : Colors.black,
            )),
      ),
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Filter by ~"),
                ),
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
                                      DateTime now = DateTime(year, 1);
                                      var firstDayofYear =
                                          DateTime(now.year, now.month, 1);

                                      print(firstDayofYear);

                                      DateTime now2 = DateTime(year, 12);
                                      var lastDayofYear = DateTime(
                                          now2.year, now2.month + 1, 0);

                                      print(lastDayofYear);

                                      salesController.getGraphSales(
                                          fromDate: firstDayofYear,
                                          toDate: lastDayofYear);
                                      salesController.salesdata.refresh();

                                      Get.back();
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            year.toString().capitalize!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Divider()
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
                    padding: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        Obx(() =>
                            Text(salesController.currentYear.value.toString())),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Text(
              "TOTAL PROFIT(net) ${htmlPrice(salesController.netProfit.value)}",
              style: TextStyle(
                  color: AppColors.mainColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: DefaultTabController(
                initialIndex: salesController.tableInitialIndex.value,
                length: 2,
                child: Builder(builder: (context) {
                  return Column(
                    children: [
                      TabBar(
                        controller: DefaultTabController.of(context),
                        tabs: [
                          Tab(
                            child: Text(
                              "Graph View",
                              style: TextStyle(color: AppColors.mainColor),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "List View",
                              style: TextStyle(color: AppColors.mainColor),
                            ),
                          )
                        ],
                        onTap: (i) {
                          salesController.tableInitialIndex.value = i;
                        },
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                // Chart title
                                title: ChartTitle(
                                    text: 'Sales, Profit and Expenses'),
                                // Enable legend
                                legend: Legend(isVisible: true),
                                // Enable tooltip
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<SalesData, String>>[
                                  LineSeries<SalesData, String>(
                                      dataSource: salesController.salesdata,
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales,
                                      name: 'Sales',
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true)),
                                  LineSeries<SalesData, String>(
                                      dataSource: salesController.profitdata,
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales,
                                      name: 'Profit',
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true)),
                                  LineSeries<SalesData, String>(
                                      dataSource: salesController.expensesdata,
                                      xValueMapper: (SalesData sales, _) =>
                                          sales.year,
                                      yValueMapper: (SalesData sales, _) =>
                                          sales.sales,
                                      name: 'Expenses',
                                      // Enable data label
                                      dataLabelSettings:
                                          DataLabelSettings(isVisible: true))
                                ]),
                            DataTable2(
                              columnSpacing: 5,
                              horizontalMargin: 5,
                              minWidth: 400,
                              columns: const [
                                DataColumn2(
                                  label: Text('Month'),
                                  size: ColumnSize.L,
                                ),
                                DataColumn(
                                  label: Text('Sales '),
                                ),
                                DataColumn(
                                  label: Text('Sales\nProfit'),
                                ),
                                DataColumn(
                                  label: Text('Expenses'),
                                ),
                                DataColumn(
                                  label: Text('Profit'),
                                ),
                              ],
                              rows: List<DataRow>.generate(
                                  salesController.salesdata.length, (index) {
                                SalesData saledata =
                                    salesController.salesdata.elementAt(index);
                                SalesData expenses = salesController
                                    .expensesdata
                                    .elementAt(index);
                                SalesData profitdata =
                                    salesController.profitdata.elementAt(index);

                                return DataRow(cells: [
                                  DataCell(Text(saledata.year)),
                                  DataCell(Text(saledata.sales.toString())),
                                  DataCell(Text(profitdata.sales.toString())),
                                  DataCell(Text(expenses.sales.toString())),
                                  DataCell(Text(
                                      (profitdata.sales - expenses.sales)
                                          .toString()))
                                ]);
                              }),
                              fixedLeftColumns: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => salesController.tableInitialIndex.value == 0
            ? Container(
                height: 0,
              )
            : Container(
                height: 120,
                child: DataTable2(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    minWidth: 400,
                    columns: [
                      DataColumn2(
                        label: Text(''),
                        size: ColumnSize.L,
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                      DataColumn(
                        label: Text(''),
                      ),
                    ],
                    rows: List<DataRow>.generate(1, (index) {
                      var salestotal = salesController.salesdata.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.sales.toInt());
                      var expenses = salesController.expensesdata.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.sales.toInt());
                      var profitdata = salesController.profitdata.fold(
                          0,
                          (previousValue, element) =>
                              previousValue + element.sales.toInt());

                      return DataRow(cells: [
                        DataCell(Text(
                          "Totals",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataCell(Text(htmlPrice(salestotal))),
                        DataCell(Text(
                          htmlPrice(profitdata.toString()),
                          style: TextStyle(color: Colors.green),
                        )),
                        DataCell(Text(htmlPrice(expenses.toString()),
                            style: TextStyle(color: Colors.red))),
                        DataCell(Text(
                            htmlPrice((profitdata - expenses).toString()),
                            style: TextStyle(
                                color: (profitdata - expenses) < 0
                                    ? Colors.red
                                    : Colors.green)))
                      ]);
                    })),
              ),
      ),
    );
  }
}
