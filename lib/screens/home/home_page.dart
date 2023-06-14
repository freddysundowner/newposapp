import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
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
import '../../controllers/sales_controller.dart';
import '../../services/sales.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../customers/customers_page.dart';
import '../finance/finance_page.dart';
import '../sales/all_sales.dart';
import '../stock/stock_page.dart';

class HomePage extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.put(SalesController());
  UserController attendantController = Get.put(UserController());

  AuthController authController = Get.find<AuthController>();
  final DateTime now = DateTime.now();

  var fromDate = DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now()));
  var toDate = DateTime.parse(
      DateFormat("yyy-MM-dd").format(DateTime.now().add(Duration(days: 1))));
  @override
  Widget build(BuildContext context) {
    salesController.getSalesByDate(fromDate: fromDate, toDate: toDate);
    return ResponsiveWidget(
        largeScreen: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        majorTitle(
                            title: "Current Shop",
                            color: Colors.black,
                            size: 20.0),
                        const SizedBox(height: 5),
                        Obx(() {
                          return minorTitle(
                              title: shopController.currentShop.value == null
                                  ? ""
                                  : shopController.currentShop.value!.name,
                              color: AppColors.mainColor);
                        }),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: AppColors.mainColor, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          minorTitle(
                              title: "Change Shop", color: AppColors.mainColor),
                          const SizedBox(width: 10),
                          PopupMenuButton(
                            itemBuilder: (ctx) => shopController.allShops
                                .map(
                                  (element) => PopupMenuItem(
                                    child: ListTile(
                                      onTap: () async {
                                        shopController.currentShop.value =
                                            element;
                                        Get.back();
                                      },
                                      title: Text(element.name!),
                                    ),
                                  ),
                                )
                                .toList(),
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: showTodaySales(context),
                ),
                SizedBox(
                  height: 30,
                ),
                majorTitle(title: "Services", color: Colors.black, size: 20.0),
                SizedBox(height: 20),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          width: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.1)),
                          padding: EdgeInsets.all(10),
                          child: gridItems(
                              title: "Sell",
                              iconData: Icons.sell_rounded,
                              isSmallScreen: false,
                              function: () {
                                Get.find<HomeController>()
                                    .selectedWidget
                                    .value = CreateSale();
                              }),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          width: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.1)),
                          padding: EdgeInsets.all(10),
                          child: gridItems(
                              title: "Finance",
                              isSmallScreen: false,
                              iconData: Icons.request_quote_outlined,
                              function: () {
                                Get.find<HomeController>()
                                    .selectedWidget
                                    .value = FinancePage();
                              }),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            width: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.1)),
                            padding: EdgeInsets.all(10),
                            child: gridItems(
                                title: "Stock",
                                isSmallScreen: false,
                                iconData: Icons.production_quantity_limits,
                                function: () {
                                  Get.find<HomeController>()
                                      .selectedWidget
                                      .value = StockPage();
                                })),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          width: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.1)),
                          padding: EdgeInsets.all(10),
                          child: gridItems(
                              title: "Suppliers",
                              iconData: Icons.people_alt,
                              isSmallScreen: false,
                              function: () {
                                Get.find<HomeController>()
                                    .selectedWidget
                                    .value = SuppliersPage();
                              }),
                        ),
                        Container(
                            margin: EdgeInsets.only(right: 20),
                            width: MediaQuery.of(context).size.height * 0.2,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.withOpacity(0.1)),
                            padding: EdgeInsets.all(10),
                            child: gridItems(
                                title: "Customers",
                                iconData: Icons.people_outline_outlined,
                                isSmallScreen: false,
                                function: () {
                                  Get.find<HomeController>()
                                      .selectedWidget
                                      .value = CustomersPage();
                                })),
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          width: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.1)),
                          padding: EdgeInsets.all(10),
                          child: gridItems(
                              title: "Usage",
                              iconData: Icons.data_usage,
                              isSmallScreen: false,
                              function: () {
                                Get.to(() => ExtendUsage());
                              }),
                        ),
                      ],
                    )),
                SizedBox(height: 20),
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      majorTitle(
                          title: "Sales", color: Colors.black, size: 20.0),
                      salesController.allSales.isEmpty
                          ? Container()
                          : InkWell(
                              onTap: () {
                                salesController.salesInitialIndex.value = 0;
                                salesController.activeItem.value = "All Sales";
                                Get.find<HomeController>()
                                    .selectedWidget
                                    .value = AllSalesPage(page: "homePage");
                              },
                              child: majorTitle(
                                  title: "View All",
                                  color: AppColors.mainColor,
                                  size: 15.0)),
                    ],
                  );
                }),
                SizedBox(height: 10),
                Obx(() {
                  return salesController.loadingSales.value
                      ? Center(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              CircularProgressIndicator(),
                            ],
                          ),
                        )
                      : salesController.allSales.length == 0
                          ? Center(child: noItemsFound(context, false))
                          : salesTable(context, "home");
                }),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        smallScreen: RefreshIndicator(
          onRefresh: () async {
            await shopController.getShops();
          },
          child: Scaffold(
              body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 50),
                  Row(
                    children: [
                      majorTitle(
                          title: "Current Shop",
                          color: Colors.black,
                          size: 20.0),
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
                      if (checkPermission(
                          category: 'shop', permission: "switch"))
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
                              border: Border.all(
                                  color: AppColors.mainColor, width: 2),
                            ),
                            child: minorTitle(
                                title: "Switch Shop",
                                color: AppColors.mainColor),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  showTodaySales(context),
                  SizedBox(height: 20),
                  majorTitle(
                      title: "Enterprise Operations",
                      color: Colors.black,
                      size: 20.0),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Obx(
                      () => GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        children: [
                          if (checkPermission(
                              category: "sales", permission: "add"))
                            gridItems(
                                title: "Sell",
                                iconData: Icons.sell_rounded,
                                isSmallScreen: true,
                                function: () {
                                  Get.to(() => CreateSale());
                                }),
                          if (checkPermission(
                              category: "accounts", group: true))
                            gridItems(
                                title: "Finance",
                                isSmallScreen: true,
                                iconData: Icons.request_quote_outlined,
                                function: () {
                                  Get.to(() => FinancePage());
                                }),
                          if (checkPermission(category: "stocks", group: true))
                            gridItems(
                                title: "Stock",
                                isSmallScreen: true,
                                iconData: Icons.production_quantity_limits,
                                function: () {
                                  Get.to(() => StockPage());
                                }),
                          if (checkPermission(
                              category: "suppliers", group: true))
                            gridItems(
                                title: "Suppliers",
                                iconData: Icons.people_alt,
                                isSmallScreen: true,
                                function: () {
                                  Get.to(() => SuppliersPage());
                                }),
                          if (checkPermission(
                              category: "customers", group: true))
                            gridItems(
                                title: "Customers",
                                iconData: Icons.people_outline_outlined,
                                isSmallScreen: true,
                                function: () {
                                  Get.to(() => CustomersPage());
                                }),
                          if (checkPermission(category: "usage", group: true))
                            gridItems(
                                title: "Usage",
                                iconData: Icons.data_usage,
                                isSmallScreen: true,
                                function: () {
                                  Get.to(() => ExtendUsage());
                                }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      majorTitle(
                          title: "Sales History",
                          color: Colors.black,
                          size: 20.0),
                      InkWell(
                          onTap: () {
                            salesController.salesInitialIndex.value = 0;
                            salesController.getSales();

                            Get.to(() => AllSalesPage(
                                  page: "homePage",
                                ));
                          },
                          child: minorTitle(
                              title: "See all",
                              color: AppColors.lightDeepPurple))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return salesController.getSalesByLoad.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : salesListView();
                  })
                ],
              ),
            ),
          )),
        ));
  }

  Widget gridItems(
      {required title,
      required IconData iconData,
      required function,
      required isSmallScreen}) {
    return InkWell(
      child: Column(
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
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isSmallScreen ? Colors.white : AppColors.mainColor,
            ),
          ),
        ],
      ),
      onTap: () {
        function();
      },
    );
  }

  Widget showTodaySales(context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: AppColors.mainColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: "Today's Sale", color: Colors.white, size: 18.0),
              SizedBox(height: 10),
              Obx(() {
                return salesController.getSalesByLoad.value
                    ? minorTitle(title: "Calculating...", color: Colors.white)
                    : normalText(
                        title: htmlPrice(salesController.totalSalesByDate),
                        color: Colors.white,
                        size: 14.0);
              }),
            ],
          ),
          InkWell(
            onTap: () {
              if (MediaQuery.of(context).size.width > 600) {
                salesController.salesInitialIndex.value = 2;
                salesController.activeItem.value = "Today";
                salesController.getSales();
                ;
                Get.find<HomeController>().selectedWidget.value = AllSalesPage(
                  page: "homePage",
                );
              } else {
                salesController.salesInitialIndex.value = 2;
                salesController.getSalesByDate(
                    fromDate: fromDate, toDate: toDate);
                Get.to(() => AllSalesPage(
                      page: "homePage",
                    ));
              }
            },
            child:
                majorTitle(title: "View More", color: Colors.white, size: 18.0),
          ),
        ],
      ),
    );
  }

  Widget salesListView() {
    return StreamBuilder(
        stream: Sales().getSales().changes,
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

                  return SalesCard(salesModel: salesModel);
                });
          }
        });
  }
}
