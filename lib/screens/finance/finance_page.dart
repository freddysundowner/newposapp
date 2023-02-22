import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/screens/finance/profit_page.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../utils/dates.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../sales/all_sales_page.dart';
import 'expense_page.dart';

class FinancePage extends StatelessWidget {
  FinancePage({Key? key}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  @override
  Widget build(BuildContext context) {
    var startDate = converTimeToMonth()["startDate"];
    var endDate = converTimeToMonth()["endDate"];
    salesController.getProfitTransaction(
        start: startDate,
        end: endDate,
        type: "finance",
        shopId: shopController.currentShop.value?.id);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: majorTitle(title: "Financial", color: Colors.black, size: 16.0),
      ),
      body: SingleChildScrollView(
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
              Container(
                // padding: EdgeInsets.fromLTRB(10,5,10,5),
                width: double.infinity,
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
              ),
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
                    amount:
                        "${salesController.profitModel.value?.shopProfit == null ? 0 : salesController.profitModel.value?.shopProfit}");
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
                  amount:
                      "${salesController.profitModel.value == null ? 0 : salesController.profitModel.value!.expense!.length == 0 ? 0 : salesController.profitModel.value?.expense![0].totalAmount}",
                );
              }),
              Obx(() {
                return financeCards(
                  title: "Sales",
                  subtitle: "sales",
                  onPresssed: () {
                    Get.to(() => AllSalesPage());
                  },
                  color: Colors.blue.shade100,
                  icon: Icons.sell_rounded,
                  amount:
                      "${salesController.profitModel.value == null ? 0 : salesController.profitModel.value!.totalsales!.length == 0 ? 0 : salesController.profitModel.value?.totalsales![0].totalAmount}",
                );
              }),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
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
        width: double.infinity,
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
                    " This month ${title} is ${shopController.currentShop.value?.currency}.${amount} ",
                color: Colors.black,
                size: 14.0)
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
