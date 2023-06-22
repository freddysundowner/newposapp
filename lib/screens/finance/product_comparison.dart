import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/sales_controller.dart';

class ProductAnalysis extends StatelessWidget {
  ProductAnalysis({Key? key}) : super(key: key);

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

  String getMonth(int monthNumber) {
    String? month = "";
    switch (monthNumber) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
    }
    return month;
  }

  @override
  Widget build(BuildContext context) {
    salesController.getProductComparison();

    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(salesController.filterTitle.value),
                SizedBox(
                  width: 20,
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
                                itemCount: 12,
                                itemBuilder: (c, i) {
                                  var monthIndex = i + 1;
                                  var month = getMonth(monthIndex);
                                  return InkWell(
                                    onTap: () {
                                      _filterProductsComparion(monthIndex);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            month,
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
                        Obx(() => Text(
                            getMonth(salesController.selectedMonth.value))),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
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
                                      _filterProductsComparion(
                                          salesController.selectedMonth.value);
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
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Fast & Slow moving products",
              style: TextStyle(fontSize: 21),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true),
                    primaryXAxis: CategoryAxis(isVisible: true),
                    series: <ChartSeries<ChartData, String>>[
                  // Renders column chart
                  ColumnSeries<ChartData, String>(
                      dataSource: salesController.productsDatadata,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ])),
          ]),
        ),
      ),
    );
  }

  void _filterProductsComparion(int monthIndex) {
    var year = salesController.currentYear.value;
    salesController.selectedMonth.value = monthIndex;
    DateTime now = DateTime(year, monthIndex);
    var firstDayofYear = DateTime(now.year, monthIndex, 1);

    print(firstDayofYear);

    DateTime now2 = DateTime(year, monthIndex);
    var lastDayofYear = DateTime(now2.year, now2.month + 1, 0);

    print(lastDayofYear);

    salesController.getProductComparison(
        fromDate: firstDayofYear, toDate: lastDayofYear);
    salesController.productsDatadata.refresh();
    Get.back();
  }
}
