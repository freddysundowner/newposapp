import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:flutterpos/screens/stock/badstocks.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:flutterpos/widgets/pdf/sales_pdf.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/sold_card.dart';
import '../finance/finance_page.dart';
import '../finance/profit_page.dart';
import '../home/home_page.dart';
import 'components/sales_table.dart';

class AllSalesPage extends StatelessWidget {
  final page;

  AllSalesPage({Key? key, required this.page}) : super(key: key) {
    salesController.getSalesByShop(id: shopController.currentShop.value?.id);
  }

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  HomeController homeController = Get.find<HomeController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        salesController.getSalesByDates(
            shopId: shopController.currentShop.value?.id,
            startingDate: DateTime.now(),
            endingDate: DateTime.now(),
            type: "notcashflow");
        return true;
      },
      child: ResponsiveWidget(
        largeScreen: _body(context),
        smallScreen: _body(context),
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
                  if (authController.usertype == "admin")
                    majorTitle(title: "Sales", color: Colors.black, size: 18.0),
                  Spacer(),
                  if (authController.usertype == "attendant")
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
                            title: Text("Create Sale"),
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Get.back();
                              if (MediaQuery.of(context).size.width > 600) {
                                homeController.selectedWidget.value =
                                    BadStockPage(
                                  page: "sales",
                                );
                              } else {
                                Get.to(() => BadStockPage(page: "sales"));
                              }
                            },
                            title: Text("BadStock"),
                          ),
                        ),
                      ],
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                ],
              ),
              leading: Get.find<AuthController>().usertype == "attendant" &&
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
                if (authController.usertype=="admin")
                IconButton(
                    onPressed: () {
                      SalesPdf(
                          shop: shopController.currentShop.value!.name!,
                          sales: salesController.sales,
                          type: salesController.salesInitialIndex.value == 0
                              ? "All"
                              : salesController.salesInitialIndex.value == 1
                                  ? "Credit"
                                  : "Today");
                    },
                    icon: Icon(
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
                    salesController.getSalesByShop(
                        id: shopController.currentShop.value?.id);
                  } else if (value == 1) {
                    salesController.getSalesOnCredit(
                      shopId: shopController.currentShop.value?.id,
                    );
                  } else {
                    salesController.getSalesByDates(
                        shopId: shopController.currentShop.value?.id,
                        startingDate: DateTime.now(),
                        endingDate: DateTime.now(),
                        type: "notcashflow");
                  }
                },
                tabs: [
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
                          ? SalesOnCredit()
                          : TodaySales()
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

  AllSales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.salesByShopLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.sales.length == 0
              ? Center(
                  child: normalText(
                      title: "No entries found${salesController.sales.length}",
                      color: Colors.black,
                      size: 14.0),
                )
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          salesTable(context, "sales"),
                          SizedBox(
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
                                      Text("Total Sales:"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${shopController.currentShop.value?.currency} ${salesController.totalSales()}"),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: salesController.sales.length,
                      itemBuilder: (context, index) {
                        SalesModel salesModel =
                            salesController.sales.elementAt(index);
                        return soldCard(
                            salesModel: salesModel, context: context);
                      });
    });
  }
}

class TodaySales extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController createShopController = Get.find<ShopController>();

  TodaySales({Key? key}) : super(key: key) {
    salesController.getSalesByDates(
        shopId: createShopController.currentShop.value?.id,
        startingDate: DateTime.now(),
        endingDate: DateTime.now(),
        type: "notcashflow");
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.todaySalesLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.sales.length == 0
              ? Center(
                  child: normalText(
                      title: "No sales made today",
                      color: Colors.black,
                      size: 14.0),
                )
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          salesTable(context, "sales"),
                          SizedBox(
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
                                      Text("Total Sales:"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${createShopController.currentShop.value?.currency} ${salesController.totalSales()}"),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: salesController.sales.length,
                      itemBuilder: (context, index) {
                        SalesModel salesModel =
                            salesController.sales.elementAt(index);
                        return soldCard(
                            salesModel: salesModel, context: context);
                      });
    });
  }
}

class SalesOnCredit extends StatelessWidget {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  SalesOnCredit({Key? key}) : super(key: key) {
    salesController.getSalesOnCredit(
      shopId: shopController.currentShop.value?.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.salesOnCreditLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.sales.length == 0
              ? Center(
                  child: normalText(
                      title: "No sales made on credit",
                      color: Colors.black,
                      size: 14.0),
                )
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          salesTable(context, "sales"),
                          SizedBox(
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
                                      Text("Total Sales:"),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${shopController.currentShop.value?.currency} ${salesController.totalSales()}"),
                                    ],
                                  ),
                                  Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: salesController.sales.length,
                      itemBuilder: (context, index) {
                        SalesModel salesModel =
                            salesController.sales.elementAt(index);
                        return soldCard(
                            salesModel: salesModel, context: context);
                      });
    });
  }
}
