import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:flutterpos/screens/stock/badstocks.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:flutterpos/widgets/pdf/sales_pdf.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  AllSalesPage({Key? key, required this.page}) : super(key: key) {}

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  HomeController homeController = Get.find<HomeController>();
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();

  @override
  Widget build(BuildContext context) {
    print(page);
    return WillPopScope(
      onWillPop: () async {
        salesController.getSalesByShop(
            id: shopController.currentShop.value?.id,
            attendantId: authController.usertype.value == "admin"
                ? ""
                : attendantController.attendant.value!.id,
            onCredit: "",
            startingDate: DateFormat("yyyy-MM-dd").format(DateTime.now()));

        return true;
      },
      child: ResponsiveWidget(
        largeScreen: _body(context),
        smallScreen: _body(context),
      ),
    );
  }

  Widget _body(context) {
    print("user type ${authController.usertype.value}");
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
                  if (authController.usertype.value == "admin")
                    majorTitle(title: "Sales", color: Colors.black, size: 18.0),
                  const Spacer(),
                  if (authController.usertype.value == "attendant")
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
              leading: Get.find<AuthController>().usertype.value ==
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
                if (authController.usertype == "admin")
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
                        id: shopController.currentShop.value?.id,
                        attendantId: page == "AtedantLanding"
                            ? attendantController.attendant.value!.id
                            : "",
                        onCredit: "",
                        startingDate: "");
                  } else if (value == 1) {
                    salesController.getSalesByShop(
                        id: shopController.currentShop.value?.id,
                        attendantId: page == "AtedantLanding"
                            ? attendantController.attendant.value!.id
                            : "",
                        onCredit: true,
                        startingDate: "");
                  } else {
                    salesController.getSalesByShop(
                        id: shopController.currentShop.value?.id,
                        attendantId: authController.usertype == "admin"
                            ? ""
                            : attendantController.attendant.value!.id,
                        onCredit: "",
                        startingDate:
                            "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
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
                      title: "No entries found",
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
