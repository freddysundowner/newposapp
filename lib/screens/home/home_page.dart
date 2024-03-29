import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/screens/product/products_page.dart';
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
import '../../controllers/realm_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../services/sales.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../customers/customers_page.dart';
import '../finance/expense_page.dart';
import '../finance/financial_page.dart';
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
    // {"title": "Usage", "icon": Icons.data_usage, "category": "usage"},
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Obx(
              //   () => (shopController.checkIfTrial() ||
              //       shopController.checkDaysRemaining() < 10)  && userController.user.value?.usertype == "admin"
              //       ? Container(
              //           padding: const EdgeInsets.symmetric(
              //               vertical: 10, horizontal: 20),
              //           decoration: BoxDecoration(
              //             color: Colors.red,
              //             borderRadius: BorderRadius.circular(8),
              //           ),
              //           child: Center(
              //             child: Obx(
              //               () => Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 mainAxisAlignment: shopController.checkIfTrial()
              //                     ? MainAxisAlignment.spaceBetween
              //                     : MainAxisAlignment.start,
              //                 children: [
              //                   if (shopController.checkIfTrial())
              //                     const Text(
              //                       "You are using trial period",
              //                       style: TextStyle(color: Colors.white),
              //                     ),
              //                   if (!shopController.checkIfTrial() &&
              //                       shopController.checkDaysRemaining() < 10)
              //                     Text(
              //                       "${shopController.checkDaysRemaining()} days remaining",
              //                       style: const TextStyle(color: Colors.white),
              //                     ),
              //                   if (shopController.checkIfTrial())
              //                     InkWell(
              //                       onTap: () {
              //                         isSmallScreen(context)
              //                             ? Get.to(() => ExtendUsage())
              //                             : Get.find<HomeController>()
              //                                 .selectedWidget
              //                                 .value = ExtendUsage();
              //                       },
              //                       child: Container(
              //                         padding: const EdgeInsets.symmetric(
              //                             horizontal: 10, vertical: 4),
              //                         decoration: BoxDecoration(
              //                           color: Colors.white,
              //                           borderRadius: BorderRadius.circular(50),
              //                         ),
              //                         child: const Text(
              //                           "Upgrade now",
              //                           style: TextStyle(color: Colors.red),
              //                         ),
              //                       ),
              //                     )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         )
              //       : Container(),
              // ),
              Row(
                children: [
                  majorTitle(
                      title: "Current Shop", color: Colors.black, size: 20.0),
                  const SizedBox(
                    width: 5,
                  ),
                  // majorTitle(
                  //     title: shopController.checkSubscription() == false
                  //         ? "Expired"
                  //         : "Active",
                  //     color: shopController.checkSubscription()
                  //         ? Colors.green
                  //         : Colors.red,
                  //     size: 10.0),
                  if (userController.user.value?.usertype == "attendant")
                    const Spacer(),
                  if (userController.user.value?.usertype == "attendant")
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              try {
                                await userController.getUser();
                                // ignore: use_build_context_synchronously
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const AlertDialog(
                                        content: Row(
                                          children: [
                                            CircularProgressIndicator(),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text("Just a moment"),
                                            )
                                          ],
                                        ),
                                      );
                                    });

                                Timer(const Duration(milliseconds: 3000), () {
                                  Get.back();
                                  userController.user.refresh();
                                });
                              } catch (e) {
                                Get.back();
                              }
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
                            : "${shopController.currentShop.value!.name} ",
                        color: AppColors.mainColor);
                  }),
                  if (checkPermission(category: 'shop', permission: "switch"))
                    InkWell(
                      onTap: () async {
                        await shopController.getShops();
                        showShopModalBottomSheet(Get.context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
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
              const SizedBox(height: 20),
              Obx(
                () {
                  return salesController.homecards.isEmpty
                      ? Container()
                      : SizedBox(
                          height: 100,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Expanded(
                                child: isSmallScreen(context)
                                    ? PageView.builder(
                                        scrollDirection: Axis.horizontal,
                                        controller: PageController(
                                            viewportFraction: 0.8,
                                            initialPage: 1,
                                            keepPage: false),
                                        onPageChanged: (value) {},
                                        itemCount:
                                            salesController.homecards.length,
                                        itemBuilder: (context, index) {
                                          return showTodaySales(
                                              context,
                                              index,
                                              salesController.homecards
                                                  .elementAt(index));
                                        })
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            salesController.homecards.length,
                                        itemBuilder: (context, index) {
                                          return showTodaySales(
                                              context,
                                              index,
                                              salesController.homecards
                                                  .elementAt(index));
                                        }),
                              )
                            ],
                          ),
                        );
                },
              ),
              const SizedBox(height: 20),

              majorTitle(
                  title: "Enterprise Operations",
                  color: Colors.black,
                  size: 20.0),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                    right: isSmallScreen(context) ? 0 : 5,
                    left: isSmallScreen(context) ? 0 : 5),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: isSmallScreen(context)
                                ? 1.05
                                : !isSmallScreen(context) &&
                                        MediaQuery.of(context).size.width < 1000
                                    ? 1.6
                                    : 2.0,
                            crossAxisCount: isSmallScreen(context) ? 3 : 4,
                            crossAxisSpacing: isSmallScreen(context) ? 2 : 10,
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
                          return isSmallScreen(context)
                              ? gridItems(
                                  title: e["title"],
                                  iconData: e["icon"],
                                  isSmallScreen: true,
                                  function: () => handleClickFunctions(
                                      context: context,
                                      title:
                                          e["title"].toString().toLowerCase()))
                              : desktopGridItems(
                                  title: e["title"],
                                  iconData: e["icon"],
                                  isSmallScreen: true,
                                  function: () => handleClickFunctions(
                                      context: context,
                                      title:
                                          e["title"].toString().toLowerCase()));
                        },
                      ),
                      if (checkPermission(category: "accounts", group: true))
                        const Divider(
                          color: Colors.white,
                        ),
                      if (checkPermission(category: "accounts", group: true))
                        InkWell(
                          onTap: shopController.checkSubscription() == false
                              ? null
                              : () {
                                  salesController.getFinanceSummary(
                                    fromDate: DateTime.parse(
                                        DateFormat("yyy-MM-dd")
                                            .format(DateTime.now())),
                                    toDate: DateTime.parse(
                                        DateFormat("yyy-MM-dd").format(
                                            DateTime.now()
                                                .add(const Duration(days: 1)))),
                                  );
                                  isSmallScreen(context)
                                      ? Get.to(() => FinancialPage())
                                      : Get.find<HomeController>()
                                          .selectedWidget
                                          .value = FinancialPage();
                                },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.auto_graph,
                                color: Colors.amber,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Profits & Expenses",
                                style: TextStyle(
                                    color: shopController.checkSubscription() ==
                                            false
                                        ? Colors.grey
                                        : Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      if (checkPermission(category: "sales", group: true))
                        const Divider(
                          color: Colors.white,
                        ),
                      if (checkPermission(category: "sales", group: true))
                        InkWell(
                          onTap: shopController.checkSubscription() == false
                              ? null
                              : () {
                                  salesController.getFinanceSummary(
                                    fromDate: DateTime.parse(
                                        DateFormat("yyy-MM-dd")
                                            .format(DateTime.now())),
                                    toDate: DateTime.parse(
                                        DateFormat("yyy-MM-dd").format(
                                            DateTime.now()
                                                .add(const Duration(days: 1)))),
                                  );
                                  isSmallScreen(context)
                                      ? Get.to(() => SalesPage())
                                      : Get.find<HomeController>()
                                          .selectedWidget
                                          .value = SalesPage();
                                },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.margin_outlined,
                                color: Colors.amber,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sales & Orders",
                                style: TextStyle(
                                    color: shopController.checkSubscription() ==
                                            false
                                        ? Colors.grey
                                        : Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 15,
                              )
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
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
                            : salesTable(context: context, page: "home");
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
    return Obx(
      () => InkWell(
        onTap: shopController.checkSubscription() == false &&
                shopController.excludefeatures
                        .contains(title.toString().toLowerCase()) ==
                    false
            ? null
            : () {
                function();
              },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: shopController.checkSubscription() == false &&
                        shopController.excludefeatures
                                .contains(title.toString().toLowerCase()) ==
                            false
                    ? Colors.grey
                    : isSmallScreen
                        ? Colors.white
                        : Colors.red,
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
            const SizedBox(height: 10),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: shopController.checkSubscription() == false
                      ? Colors.grey
                      : isSmallScreen
                          ? Colors.white
                          : AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget desktopGridItems(
      {required title,
      required IconData iconData,
      required function,
      required isSmallScreen}) {
    return Obx(
      () => InkWell(
        onTap: shopController.checkSubscription() == false &&
                shopController.excludefeatures
                        .contains(title.toString().toLowerCase()) ==
                    false
            ? null
            : () {
                function();
              },
        child: Container(
          decoration: BoxDecoration(
              color: shopController.checkSubscription() == false &&
                      shopController.excludefeatures
                              .contains(title.toString().toLowerCase()) ==
                          false
                  ? Colors.grey
                  : Colors.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 55,
                color: AppColors.mainColor,
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: shopController.checkSubscription() == false
                        ? Colors.grey
                        : AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleClickFunctions({required context, required title}) {
    switch (title) {
      case "sale":
        {
          isSmallScreen(context)
              ? Get.to(() => CreateSale())
              : Get.find<HomeController>().selectedWidget.value = CreateSale();
        }
        break;
      case "cashflow":
        {
          Get.find<CashflowController>().getCashflowSummary(
            shopId: shopController.currentShop.value!.id,
            from: DateTime.parse(DateFormat("yyyy-MM-dd")
                .format(Get.find<CashflowController>().fromDate.value)),
            to: DateTime.parse(DateFormat("yyyy-MM-dd")
                    .format(Get.find<CashflowController>().toDate.value))
                .add(const Duration(hours: 24)),
          );
          isSmallScreen(context)
              ? Get.to(() => CashFlowManager())
              : Get.find<HomeController>().selectedWidget.value =
                  CashFlowManager();
        }
        break;
      case "stock":
        {
          isSmallScreen(context)
              ? Get.to(() => StockPage())
              : Get.find<HomeController>().selectedWidget.value = StockPage();
        }
        break;
      case "suppliers":
        {
          isSmallScreen(context)
              ? Get.to(() => SuppliersPage())
              : Get.find<HomeController>().selectedWidget.value =
                  SuppliersPage();
        }
        break;
      case "customers":
        {
          isSmallScreen(context)
              ? Get.to(() => CustomersPage())
              : Get.find<HomeController>().selectedWidget.value =
                  CustomersPage();
        }
        break;
      case "usage":
        {
          isSmallScreen(context)
              ? Get.to(() => ExtendUsage())
              : Get.find<HomeController>().selectedWidget.value = ExtendUsage();
        }
        break;
    }
  }

  Widget showTodaySales(context, int index, HomeCard homeCard) {
    var c =
        Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return InkWell(
      onTap: () {
        print(homeCard.color);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: 10, horizontal: isSmallScreen(context) ? 20 : 50),
        margin: const EdgeInsets.only(left: 10, right: 10),
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
            const SizedBox(
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                majorTitle(
                    title: homeCard.name, color: Colors.white, size: 13.0),
                const SizedBox(height: 10),
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
