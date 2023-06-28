import 'package:flutter/material.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/sales/components/sales_table.dart';
import 'package:pointify/screens/sales/create_sale.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/screens/usage/extend_usage.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/sales_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/widgets/shop_list_bottomsheet.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/cashflow_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../services/sales.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../customers/customers_page.dart';
import '../finance/expense_page.dart';
import '../finance/finance_page.dart';
import '../finance/profit_page.dart';
import '../sales/all_sales.dart';
import '../sales/sales_page.dart';
import '../stock/stock_page.dart';
import 'dart:math' as math;

class HomePage extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.put(SalesController());
  ExpenseController expenseController = Get.put(ExpenseController());
  UserController attendantController = Get.put(UserController());
  AuthController authController = Get.find<AuthController>();
  final DateTime now = DateTime.now();

  var fromDate = DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now()));
  var toDate = DateTime.parse(DateFormat("yyy-MM-dd")
      .format(DateTime.now().add(const Duration(days: 1))));

  List<Map<String, dynamic>> enterpriseOperations = [
    {"title": "Sale", "icon": Icons.sell_rounded, "category": "sales"},
    {
      "title": "Cashflow",
      "icon": Icons.request_quote_outlined,
      "category": "accounts"
    },
    {
      "title": "Stock",
      "icon": Icons.production_quantity_limits,
      "category": "stocks"
    },
    {"title": "Suppliers", "icon": Icons.people_alt, "category": "suppliers"},
    {
      "title": "Customers",
      "icon": Icons.people_outline_outlined,
      "category": "customers"
    },
    {"title": "Usage", "icon": Icons.data_usage, "category": "usage"},
  ];

  @override
  Widget build(BuildContext context) {
    salesController.getSalesByDate(
        fromDate: fromDate, toDate: toDate, type: "today");
    return RefreshIndicator(
      onRefresh: () async {
        await shopController.getShops();
        salesController.getSalesByDate(type: "today");
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 50),
              Row(
                children: [
                  majorTitle(
                      title: "Current Shop", color: Colors.black, size: 20.0),
                  if (userController.user.value?.usertype == "attendant")
                    Spacer(),
                  if (userController.user.value?.usertype == "attendant")
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              userController.getUser();
                              userController.user.refresh();
                            },
                            icon: const Icon(Icons.refresh)),
                        IconButton(
                            onPressed: () async {
                              await authController.logOut();
                            },
                            icon: const Icon(
                              Icons.logout,
                              color: Colors.red,
                            )),
                      ],
                    )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    return minorTitle(
                        title: shopController.currentShop.value == null
                            ? ""
                            : shopController.currentShop.value!.name,
                        color: AppColors.mainColor);
                  }),
                  if (checkPermission(category: 'shop', permission: "switch"))
                    InkWell(
                      onTap: () async {
                        await shopController.getShops();
                        showShopModalBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: AppColors.mainColor, width: 2),
                        ),
                        child: minorTitle(
                            title: "Switch Shop", color: AppColors.mainColor),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Obx(
                      () {
                        return Expanded(
                          child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              controller: PageController(
                                  viewportFraction:
                                      isSmallScreen(context) ? 0.8 : 0.45,
                                  initialPage: 1,
                                  keepPage: false),
                              onPageChanged: (value) {},
                              itemCount: salesController.homecards.length,
                              itemBuilder: (context, index) {
                                return showTodaySales(context, index,
                                    salesController.homecards.elementAt(index));
                              }),
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              majorTitle(
                  title: "Enterprise Operations",
                  color: Colors.black,
                  size: 20.0),
              SizedBox(height: 20),
              isSmallScreen(context)
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    // childAspectRatio:
                                    //     MediaQuery.of(context).size.width *
                                    //         6 /
                                    //         MediaQuery.of(context).size.height,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            padding: EdgeInsets.zero,
                            itemCount: enterpriseOperations
                                .where((e) =>
                                    checkPermission(
                                        category: e["category"], group: true) ==
                                    true)
                                .toList()
                                .length,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (c, i) {
                              var e = enterpriseOperations.elementAt(i);
                              return gridItems(
                                  title: e["title"],
                                  iconData: e["icon"],
                                  isSmallScreen: true,
                                  function: () {
                                    switch (
                                        e["title"].toString().toLowerCase()) {
                                      case "sale":
                                        Get.to(() => CreateSale());
                                        break;
                                      case "cashflow":
                                        {
                                          Get.find<CashflowController>()
                                              .getCashflowSummary(
                                            shopId: shopController
                                                .currentShop.value!.id,
                                            from: DateTime.parse(DateFormat(
                                                    "yyyy-MM-dd")
                                                .format(Get.find<
                                                        CashflowController>()
                                                    .fromDate
                                                    .value)),
                                            to: DateTime.parse(DateFormat(
                                                        "yyyy-MM-dd")
                                                    .format(Get.find<
                                                            CashflowController>()
                                                        .toDate
                                                        .value))
                                                .add(const Duration(days: 1)),
                                          );
                                          Get.to(() => CashFlowManager());
                                        }
                                        break;
                                      case "stock":
                                        {
                                          Get.to(() => StockPage());
                                        }
                                        break;
                                      case "suppliers":
                                        {
                                          Get.to(() => SuppliersPage());
                                        }
                                        break;
                                      case "customers":
                                        {
                                          Get.to(() => CustomersPage());
                                        }
                                        break;
                                      case "usage":
                                        {
                                          Get.to(() => StockPage());
                                        }
                                        break;
                                    }
                                  });
                            },
                          ),
                          if (checkPermission(
                              category: "accounts", group: true))
                            Divider(
                              color: Colors.white,
                            ),
                          if (checkPermission(
                              category: "accounts", group: true))
                            InkWell(
                              onTap: () {
                                Get.to(() => FinancePage());
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.auto_graph,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Profits & Expenses",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                ],
                              ),
                            ),
                          if (checkPermission(category: "sales", group: true))
                            Divider(
                              color: Colors.white,
                            ),
                          if (checkPermission(category: "sales", group: true))
                            InkWell(
                              onTap: () {
                                Get.to(() => SalesPage());
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.margin_outlined,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Sales & Orders",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.2,
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: enterpriseOperations
                            .where((e) =>
                                checkPermission(
                                    category: e["category"], group: true) ==
                                true)
                            .toList()
                            .length,
                        itemBuilder: (context, index) {
                          var e = enterpriseOperations[index];
                          return Container(
                            margin: EdgeInsets.only(right: 20),
                            width: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.1)),
                            padding: EdgeInsets.all(10),
                            child: gridItems(
                                title: e["title"],
                                iconData: e["icon"],
                                isSmallScreen: false,
                                function: () {
                                  switch (e["title"].toString().toLowerCase()) {
                                    case "sale":
                                      Get.find<HomeController>()
                                          .selectedWidget
                                          .value = CreateSale();
                                      break;
                                    case "cashflow":
                                      {
                                        Get.find<CashflowController>()
                                            .getCashflowSummary(
                                          shopId: shopController
                                              .currentShop.value!.id,
                                          from: DateTime.parse(
                                              DateFormat("yyyy-MM-dd").format(
                                                  Get.find<CashflowController>()
                                                      .fromDate
                                                      .value)),
                                          to: DateTime.parse(DateFormat(
                                                      "yyyy-MM-dd")
                                                  .format(Get.find<
                                                          CashflowController>()
                                                      .toDate
                                                      .value))
                                              .add(const Duration(days: 1)),
                                        );
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = CashFlowManager();
                                      }
                                      break;
                                    case "stock":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = StockPage();
                                      }
                                      break;
                                    case "suppliers":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = SuppliersPage();
                                      }
                                      break;
                                    case "customers":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = CustomersPage();
                                      }
                                      break;
                                    case "usage":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = ExtendUsage();
                                      }
                                      break;
                                  }
                                }),
                          );
                        },
                      )),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  majorTitle(
                      title: "Sales History", color: Colors.black, size: 20.0),
                  InkWell(
                      onTap: () {
                        salesController.salesInitialIndex.value = 0;
                        salesController.getSales();
                        if (isSmallScreen(context)) {
                          Get.to(() => AllSalesPage(
                                page: "homePage",
                              ));
                        } else {
                          Get.find<HomeController>().selectedWidget.value =
                              AllSalesPage(
                            page: "homePage",
                          );
                        }
                      },
                      child: minorTitle(
                          title: "See all", color: AppColors.lightDeepPurple))
                ],
              ),
              const SizedBox(height: 10),
              Obx(() {
                return salesController.getSalesByLoad.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : salesController.allSales.isEmpty
                        ? Center(child: noItemsFound(context, false))
                        : isSmallScreen(context)
                            ? salesListView()
                            : salesTable(context, "home");
              })
            ],
          ),
        ),
      )),
    );
  }

  Widget gridItems(
      {required title,
      required IconData iconData,
      required function,
      required isSmallScreen}) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSmallScreen ? Colors.white : Colors.transparent,
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                iconData,
                size: 40,
                color: AppColors.mainColor,
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSmallScreen ? Colors.white : AppColors.mainColor,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        function();
      },
    );
  }

  Widget showTodaySales(context, int index, HomeCard homeCard) {
    var c =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          color: homeCard.color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            homeCard.iconData,
            size: 40,
            color: c,
          ),
          SizedBox(
            width: 40,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              majorTitle(title: homeCard.name, color: Colors.white, size: 13.0),
              SizedBox(height: 10),
              Obx(() {
                return salesController.getSalesByLoad.value
                    ? minorTitle(title: "Calculating...", color: Colors.white)
                    : normalText(
                        title: htmlPrice(homeCard.total),
                        color: Colors.white,
                        size: 20.0);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget salesListView() {
    return StreamBuilder(
        stream: Sales()
            .getSales(
                fromDate: salesController.filterStartDate.value,
                toDate: salesController.filterEndDate.value)
            .changes,
        builder: (context, snapshot) {
          final data = snapshot.data;
          if (data == null) {
            return minorTitle(
                title: "This shop doesn't have products yet",
                color: Colors.black);
          } else {
            final results = data.results;
            return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.realm.isClosed ? 0 : results.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  SalesModel salesModel = results.elementAt(index);
                  // return Container();
                  return SalesCard(salesModel: salesModel);
                });
          }
        });
  }
}
