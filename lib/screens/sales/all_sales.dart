import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/sales/create_sale.dart';
import 'package:pointify/screens/stock/badstocks.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/pdf/sales_pdf.dart';
import 'package:pointify/widgets/sales_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../finance/finance_page.dart';
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
    return ResponsiveWidget(
      largeScreen: _body(context),
      smallScreen: _body(context),
    );
  }

  DateTime? fromDate;
  DateTime? toDate;

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
          if (salesController.salesInitialIndex.value != 2)
            IconButton(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: Get.context!,
                    lastDate: DateTime(2079),
                    firstDate: DateTime(2019),
                  );
                  fromDate = picked!.start;
                  toDate = picked.end;
                  salesController.getSales(
                      fromDate: picked.start, toDate: picked.end);
                },
                icon: Icon(Icons.date_range))
        ],
      ),
    );
  }

  Widget _body(context) {
    return Obx(() => DefaultTabController(
          length: salesController.tabController.length,
          initialIndex: salesController.salesInitialIndex.value,
          child: Helper(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.3,
              centerTitle: false,
              title: Row(
                children: [
                  if (usercontroller.user.value?.usertype == "admin")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        majorTitle(
                            title: "Sales", color: Colors.black, size: 18.0),
                        if (toDate != null)
                          Obx(
                            () => Text(
                              "${DateFormat("yyyy-MM-dd").format(fromDate!)} - ${DateFormat("yyyy-MM-dd").format(toDate!)}",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 13),
                            ),
                          )
                      ],
                    ),
                  const Spacer(),
                  if (usercontroller.user.value?.usertype == "attendant")
                    PopupMenuButton(
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Get.back();
                              if (MediaQuery.of(context).size.width > 600) {
                                homeController.selectedWidget.value =
                                    CreateSale(
                                  page: "allSales",
                                );
                              } else {
                                Get.to(() => CreateSale(page: "allSales"));
                              }
                            },
                            title: const Text("Create Sale"),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Get.back();
                              if (MediaQuery.of(context).size.width > 600) {
                                homeController.selectedWidget.value =
                                    BadStockPage(
                                  page: "services",
                                );
                              } else {
                                Get.to(() => BadStockPage(page: "services"));
                              }
                            },
                            title: const Text("Bad Stocks"),
                          ),
                        ),
                      ],
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                ],
              ),
              leading: Get.find<UserController>().user.value?.usertype ==
                          "attendant" &&
                      MediaQuery.of(context).size.width > 600
                  ? null
                  : IconButton(
                      onPressed: () {
                        if (MediaQuery.of(context).size.width > 600) {
                          if (page == "homePage") {
                            Get.find<HomeController>().selectedWidget.value =
                                HomePage();
                          } else if (page == "saleOrder") {
                            Get.find<HomeController>().selectedWidget.value =
                                HomePage();
                          } else if (page == "financePage") {
                            Get.find<HomeController>().selectedWidget.value =
                                FinancePage();
                          } else if (page == "profitPage") {
                            Get.find<HomeController>().selectedWidget.value =
                                ProfitPage();
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
                        SalesPdf(
                            shop: shopController.currentShop.value!.name!,
                            sales: salesController.allSales,
                            type: salesController.salesInitialIndex.value == 0
                                ? "All"
                                : salesController.salesInitialIndex.value == 1
                                    ? "Credit"
                                    : "Today");
                      },
                      icon: const Icon(
                        Icons.download_rounded,
                        color: Colors.black,
                      ))
              ],
              bottom: TabBar(
                indicatorColor: AppColors.mainColor,
                unselectedLabelColor: Colors.black,
                labelColor: AppColors.mainColor,
                onTap: (value) {
                  salesController.salesInitialIndex.value = value;
                  toDate = null;
                  fromDate = null;
                  if (value == 0) {
                    salesController.getSales();
                  } else if (value == 1) {
                    salesController.getSales(
                        fromDate: fromDate, toDate: toDate, onCredit: true);
                  } else {
                    final DateTime now = DateTime.now();
                    salesController.getSales(fromDate: now, toDate: now);
                  }
                },
                tabs: const [
                  Tab(text: 'All Sales'),
                  Tab(text: 'On Credit'),
                  Tab(text: 'Today'),
                ],
              ),
            ),
            widget: Obx(
              () => Column(
                children: [
                  searchWidget(),
                  Expanded(
                    child: TabBarView(
                      controller: salesController.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        salesController.salesInitialIndex.value == 0
                            ? AllSales()
                            : salesController.salesInitialIndex.value == 1
                                ? AllSales()
                                : AllSales()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class AllSales extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  AllSales({Key? key}) : super(key: key) {}

  _checkEmptyView() {
    if (salesController.salesInitialIndex.value == 0) {
      return salesController.allSales.isEmpty;
    }
    if (salesController.salesInitialIndex.value == 1) {
      return salesController.allSales.isEmpty;
    }
    if (salesController.salesInitialIndex.value == 2) {
      return salesController.todaySales.isEmpty;
    }
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
              : _sales();
    });
  }

  _sales() {
    print(
        "salesController.salesInitialIndex.value ${salesController.salesInitialIndex.value}");
    if (salesController.salesInitialIndex.value == 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: salesController.allSales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel = salesController.allSales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    }
    if (salesController.salesInitialIndex.value == 1) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: salesController.allSales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel = salesController.allSales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    }
    if (salesController.salesInitialIndex.value == 2) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: salesController.todaySales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel = salesController.todaySales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    }
  }
}
