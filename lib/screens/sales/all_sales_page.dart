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

import '../../Real/Models/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../finance/components/date_picker.dart';
import '../finance/finance_page.dart';
import '../finance/profit_page.dart';
import '../home/home_page.dart';
import 'components/sales_table.dart';

class AllSalesPage extends StatelessWidget {
  final page;

  AllSalesPage({Key? key, required this.page}) : super(key: key) {
    salesController.salesInitialIndex.value = 0;
    // final DateTime now = DateTime.now();
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    // salesController.getSales(date: formatted);
  }

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
                        Obx(
                          () => Text(
                            "${DateFormat("yyyy-MM-dd").format(Get.find<ExpenseController>().startdate.value)} - ${DateFormat("yyyy-MM-dd").format(Get.find<ExpenseController>().enddate.value)}",
                            style: TextStyle(color: Colors.blue, fontSize: 13),
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
                InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        lastDate: DateTime(2079),
                        firstDate: DateTime(2019),
                      );
                      salesController.getSales(
                          fromDate: picked!.start, toDate: picked.end);
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
                    )),
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
                  if (value == 0) {
                    salesController.getSales(
                        fromDate: Get.find<ExpenseController>().startdate.value,
                        toDate: Get.find<ExpenseController>().enddate.value);
                  } else if (value == 1) {
                    salesController.getSales(
                        fromDate: Get.find<ExpenseController>().startdate.value,
                        toDate: Get.find<ExpenseController>().enddate.value,
                        onCredit: true);
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
              () => TabBarView(
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
      return salesController.allSales.isEmpty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.loadingSales.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _checkEmptyView()
              ? Center(
                  child: normalText(
                      title: "No entries found",
                      color: Colors.black,
                      size: 14.0),
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
                                      Text(htmlPrice(
                                          salesController.totalSales())),
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
          itemCount: salesController.allSales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel = salesController.allSales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    }
  }
}
