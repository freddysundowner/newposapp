import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/sales/create_sale.dart';
import 'package:pointify/screens/sales/sales_page.dart';
import 'package:pointify/screens/stock/badstocks.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/sales_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../Real/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../utils/date_filter.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/bottom_widget_count_view.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/sales_rerurn_card.dart';
import '../finance/financial_page.dart';
import '../finance/profit_page.dart';
import '../home/home_page.dart';
import 'components/sales_table.dart';

class AllSalesPage extends StatelessWidget {
  final page;

  AllSalesPage({Key? key, required this.page}) : super(key: key);

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  HomeController homeController = Get.find<HomeController>();
  AuthController authController = Get.find<AuthController>();
  UserController usercontroller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return  _body(context)
    // ResponsiveWidget(
    //   largeScreen:,
    //   smallScreen: _body(context),
    // )
        ;
  }

  Widget searchWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: salesController.searchProductController,
              onChanged: (value) {
                if (value == "") {
                  salesController.getSales(
                      onCredit: salesController.salesInitialIndex.value == 1);
                } else {
                  salesController.getSales(
                      receipt: salesController.searchProductController.text,
                      onCredit: salesController.salesInitialIndex.value == 1);
                }
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 2, 0, 2),
                suffixIcon: IconButton(
                  onPressed: () {
                    salesController.getSales(
                        receipt: salesController.searchProductController.text,
                        onCredit: salesController.salesInitialIndex.value == 1);
                  },
                  icon: Icon(Icons.search),
                ),
                hintText: "Search by receipt number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _bottomView() {
    if (salesController.salesInitialIndex.value == 1) {
      return Obx(
            () => SizedBox(
          height: 40,
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text("Items"),
                  Text(
                    salesController.allSalesReturns.length.toString(),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  Text("Qty"),
                  Text(
                    salesController.allSalesReturns
                        .fold(
                        0,
                            (previousValue, element) =>
                        previousValue + element.quantity!)
                        .toString(),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text("Total"),
                  Text(
                    htmlPrice(salesController.allSalesReturns.fold(
                        0,
                            (previousValue, element) =>
                        previousValue +
                            (element.quantity! * element.price!))),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      );
    }
    return bottomWidgetCountView(
        count: salesController.allSales.length.toString(),
        qty: salesController.allSales
            .fold(
            0,
                (previousValue, element) =>
            previousValue +
                element.items.fold(
                    0,
                        (previousValue, element) =>
                    previousValue + element.quantity!))
            .toString(),
        onCrdit: htmlPrice(salesController.allSales.fold(0,
                (previousValue, element) => previousValue + element.creditTotal!)),
        cash: htmlPrice(salesController.allSales.fold(
            0,
                (previousValue, element) =>
            previousValue +
                element.items.fold(
                    0,
                        (previousValue, element) =>
                    previousValue +
                        (element.quantity! * element.price!)))));
  }

  Widget _body(context) {
    return Obx(() => DefaultTabController(
      length: salesController.tabController.length,
      initialIndex: salesController.salesInitialIndex.value,
      child: Helper(
        floatButton: Container(),
        bottomNavigationBar: _bottomView(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.3,
          centerTitle: false,
          title: usercontroller.user.value?.usertype == "admin"
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: "Sales", color: Colors.black, size: 18.0),
              Obx(
                    () => Text(
                  "${DateFormat("yyyy-MM-dd").format(salesController.filterStartDate.value)} - ${DateFormat("yyyy-MM-dd").format(salesController.filterEndDate.value)}",
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),
              )
            ],
          )
              : const Text(
            "Sales",
            style: TextStyle(color: Colors.black),
          ),
          leading: Get.find<UserController>().user.value?.usertype ==
              "attendant" &&
              MediaQuery.of(context).size.width > 600
              ? null
              : IconButton(
            onPressed: () {
              if (!isSmallScreen(context)) {
                if (page == "homePage") {
                  Get.find<HomeController>().selectedWidget.value =
                      HomePage();
                } else if (page == "saleOrder") {
                  Get.find<HomeController>().selectedWidget.value =
                      HomePage();
                } else if (page == "financePage") {
                  Get.find<HomeController>().selectedWidget.value =
                      FinancialPage();
                } else if (page == "profitPage") {
                  Get.find<HomeController>().selectedWidget.value =
                      ProfitPage();
                } else if (page == "salesPage") {
                  Get.find<HomeController>().selectedWidget.value =
                      SalesPage();
                }
              } else {
                Get.back();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          actions: [
            if (usercontroller.user.value?.usertype == "admin")
              IconButton(
                  onPressed: () {
                    // SalesPdf(
                    //     shop: shopController.currentShop.value!.name!,
                    //     sales: salesController.allSales,
                    //     type: salesController.salesInitialIndex.value == 0
                    //         ? "All"
                    //         : salesController.salesInitialIndex.value == 1
                    //             ? "Credit"
                    //             : "Today");
                  },
                  icon: const Icon(
                    Icons.download_rounded,
                    color: Colors.black,
                  )),
            IconButton(
                onPressed: () async {
                  Get.to(() => DateFilter(
                    from: "AllSalesPage",
                    page: page,
                    function: (value) {
                      if (value is PickerDateRange) {
                        final DateTime rangeStartDate =
                        value.startDate!;
                        final DateTime rangeEndDate = value.endDate!;
                        salesController.filterStartDate.value =
                            rangeStartDate;
                        salesController.filterEndDate.value =
                            rangeEndDate;
                      } else if (value is DateTime) {
                        final DateTime selectedDate = value;
                        salesController.filterStartDate.value =
                            selectedDate;
                        salesController.filterEndDate.value =
                            selectedDate;
                      }

                      salesController.getSales(
                          fromDate:
                          salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value);

                      salesController.getProductComparison(
                          fromDate:
                          salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value);
                      salesController.getDailySalesGraph(
                          fromDate:
                          salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value);

                      salesController.getReturns(
                          fromDate:
                          salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value,
                          type: "returns");
                    },
                  ));
                },
                icon: const Icon(
                  Icons.filter_alt,
                  color: Colors.black,
                ))
          ],
        ),
        widget: Builder(builder: (context) {
          return Column(
            children: [
              TabBar(
                  controller: DefaultTabController.of(context),
                  onTap: (value) {
                    salesController.salesInitialIndex.value = value;
                    if (value == 0) {
                      salesController.getSales(
                        fromDate: salesController.filterStartDate.value,
                        toDate: salesController.filterEndDate.value,
                      );
                    }

                    if (value == 1) {
                      salesController.getReturns(
                          fromDate: salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value,
                          type: "returns");
                    }

                    if (value == 2) {
                      salesController.getDailySalesGraph(
                          fromDate: salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value);
                      salesController.getProductComparison(
                          fromDate: salesController.filterStartDate.value,
                          toDate: salesController.filterEndDate.value);
                    }
                  },
                  tabs: [
                    Tab(
                        child: Row(children: [
                          Text(
                            "Sales",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ])),
                    Tab(
                        child: Text(
                          "Returns",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                    if (checkPermission(
                        category: "accounts", permission: "analysis"))
                      Tab(
                          child: Text(
                            "Analysis",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                  ]),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white,
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ListView(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          if (salesController.salesInitialIndex.value == 0)
                            searchWidget(),
                          AllSales()
                        ],
                      ),
                      AllSales(type: "returns"),
                      if (checkPermission(
                          category: "accounts", permission: "analysis"))
                        Analysis()
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    ));
  }
}

class Analysis extends StatelessWidget {
  Analysis({Key? key}) : super(key: key);

  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(isVisible: true),
              title: ChartTitle(text: "Daily Sales"),
              series: <ChartSeries<ChartData, String>>[
                // Renders column chart
                ColumnSeries<ChartData, String>(
                    dataSource: salesController.dailySales,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
          SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(isVisible: true),
              title: ChartTitle(text: "Sales by product"),
              series: <ChartSeries<ChartData, String>>[
                // Renders column chart
                ColumnSeries<ChartData, String>(
                    dataSource: salesController.productSalesAnalysis,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
          SfCartesianChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              primaryXAxis: CategoryAxis(isVisible: true),
              title: ChartTitle(text: "Sales by attendants"),
              series: <ChartSeries<ChartData, String>>[
                // Renders column chart
                ColumnSeries<ChartData, String>(
                    name: "sales",
                    dataSource:
                    salesController.productSalesByAttendantsAnalysis,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y)
              ]),
        ],
      ),
    );
  }
}

class AllSales extends StatelessWidget {
  String? type;
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  AllSales({Key? key, this.type}) : super(key: key) {}

  _checkEmptyView() {
    if (salesController.salesInitialIndex.value == 0) {
      return salesController.allSales.isEmpty;
    }
    if (salesController.salesInitialIndex.value == 1) {
      return salesController.allSalesReturns.isEmpty;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _checkEmptyView()
          ? Center(
        child: normalText(
            title: "No entries found", color: Colors.black, size: 14.0),
      )
          : MediaQuery.of(context).size.width > 600
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            salesTable(context, "services"),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 200,
                padding: EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Total Sales:"),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(htmlPrice(salesController.totalSales())),
                      ],
                    ),
                    const Divider(
                      thickness: 2,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      )
          : type == "returns"
          ? ListView.builder(
          itemCount: salesController.allSalesReturns.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            ReceiptItem receiptItem =
            salesController.allSalesReturns.elementAt(index);
            return SaleReturnCard(receiptItem);
          })
          : ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: salesController.allSales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel =
            salesController.allSales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    });
  }
}
