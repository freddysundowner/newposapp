import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/sales/components/sales_table.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/sold_card.dart';
import '../customers/customers_page.dart';
import '../finance/finance_page.dart';
import '../sales/all_sales_page.dart';
import '../stock/stock_page.dart';

class HomePage extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.put(SalesController());
  AttendantController attendantController = Get.put(AttendantController());

  HomePage({Key? key}) : super(key: key) {
    salesController.getSalesByShop(
        id: shopController.currentShop.value?.id,
        attendantId: authController.usertype == "admin"
            ? ""
            : attendantController.attendant.value!.id,
        onCredit: "",
        startingDate: "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
  }

  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
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
                        SizedBox(height: 5),
                        Obx(() {
                          return minorTitle(
                              title: shopController.currentShop.value == null
                                  ? ""
                                  : shopController.currentShop.value!.name,
                              color: AppColors.mainColor);
                        }),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () async {
                    //     await shopController.getShopsByAdminId(
                    //       adminId: authController.currentUser.value?.id,
                    //     );
                    //     showShopModalBottomSheet(context);
                    //   },
                    //   child: Container(
                    //     padding: EdgeInsets.all(5),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(50),
                    //       border:
                    //           Border.all(color: AppColors.mainColor, width: 2),
                    //     ),
                    //     child: minorTitle(
                    //         title: "Change Shop", color: AppColors.mainColor),
                    //   ),
                    // ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
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
                          SizedBox(width: 10),
                          PopupMenuButton(
                            itemBuilder: (ctx) => shopController.AdminShops!
                                .map(
                                  (element) => PopupMenuItem(
                                    child: ListTile(
                                      onTap: () {
                                        shopController.currentShop.value =
                                            element;
                                        Get.back();
                                        salesController.getSalesByShop(
                                            id: shopController
                                                .currentShop.value?.id,
                                            attendantId:
                                                authController.usertype ==
                                                        "admin"
                                                    ? ""
                                                    : attendantController
                                                        .attendant.value!.id,
                                            onCredit: "",
                                            startingDate:
                                                "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
                                      },
                                      title: Text(element.name!),
                                    ),
                                  ),
                                )
                                .toList(),
                            icon: Icon(
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
                    padding: EdgeInsets.only(top: 10),
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
                                    .value = CustomersPage(type: "supplier");
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
                                      .value = CustomersPage(type: "customers");
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
                                // Get.to(()=>ExtendUsage());
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
                      salesController.sales.length == 0
                          ? Container()
                          : InkWell(
                              onTap: () {
                                salesController.salesInitialIndex.value = 0;
                                salesController.activeItem.value = "All Sales";
                                salesController.getSalesByShop(
                                    id: shopController.currentShop.value?.id,
                                    onCredit: "");
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
                  return salesController.salesByShopLoad.value
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
                      : salesController.sales.length == 0
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
            await shopController.getShopsByAdminId(
                adminId: authController.currentUser.value!.id);
            await salesController.getSalesByShop(
                id: shopController.currentShop.value?.id,
                attendantId: authController.usertype == "admin"
                    ? ""
                    : attendantController.attendant.value!.id,
                onCredit: "",
                startingDate:
                    "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
            ;
            await Get.find<AttendantController>().getAttendantRoles();
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
                  majorTitle(
                      title: "Current Shop", color: Colors.black, size: 20.0),
                  SizedBox(height: 5),
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
                      InkWell(
                        onTap: () async {
                          await shopController.getShopsByAdminId(
                            adminId: authController.currentUser.value?.id,
                          );
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
                              title: "Change Shop", color: AppColors.mainColor),
                        ),
                      )
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
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: [
                        gridItems(
                            title: "Sell",
                            iconData: Icons.sell_rounded,
                            isSmallScreen: true,
                            function: () {
                              // homeController.selectedWidget.value=CreateSale();
                              Get.to(() => CreateSale());
                            }),
                        gridItems(
                            title: "Finance",
                            isSmallScreen: true,
                            iconData: Icons.request_quote_outlined,
                            function: () {
                              Get.to(() => FinancePage());
                            }),
                        gridItems(
                            title: "Stock",
                            isSmallScreen: true,
                            iconData: Icons.production_quantity_limits,
                            function: () {
                              Get.to(() => StockPage());
                            }),
                        gridItems(
                            title: "Suppliers",
                            iconData: Icons.people_alt,
                            isSmallScreen: true,
                            function: () {
                              Get.to(() => CustomersPage(type: "supplier"));
                            }),
                        gridItems(
                            title: "Customers",
                            iconData: Icons.people_outline_outlined,
                            isSmallScreen: true,
                            function: () {
                              Get.to(() => CustomersPage(type: "customers"));
                            }),
                        gridItems(
                            title: "Usage",
                            iconData: Icons.data_usage,
                            isSmallScreen: true,
                            function: () {
                              // Get.to(()=>ExtendUsage());
                            }),
                      ],
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
                            salesController.getSalesByShop(
                                id: shopController.currentShop.value?.id,
                                onCredit: "",
                                attendantId: "",
                                startingDate: "");

                            Get.to(() => AllSalesPage(
                                  page: "homePage",
                                ));
                          },
                          child: minorTitle(
                              title: "See all",
                              color: AppColors.lightDeepPurple))
                    ],
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    return salesController.getSalesByLoad.value
                        ? Center(
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

  showShopModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: shopController.AdminShops.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                ShopModel shopBody = shopController.AdminShops.elementAt(index);
                return InkWell(
                  onTap: () {
                    Get.back();
                    shopController.currentShop.value = shopBody;
                    salesController.getSalesByShop(
                        id: shopController.currentShop.value?.id,
                        attendantId: authController.usertype.value == "admin"
                            ? ""
                            : attendantController.attendant.value!.id,
                        onCredit: "",
                        startingDate:
                            DateFormat("yyyy-MM-dd").format(DateTime.now()));
                    ;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.shop),
                                majorTitle(
                                    title: "${shopBody.name}",
                                    color: Colors.black,
                                    size: 16.0),
                              ],
                            ),
                            const Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
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
              borderRadius: BorderRadius.all(
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
                        title:
                            "${shopController.currentShop.value?.currency}.${salesController.totalSalesByDate.value}",
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
                salesController.getSalesByShop(
                    id: shopController.currentShop.value?.id,
                    attendantId: authController.usertype == "admin"
                        ? ""
                        : attendantController.attendant.value!.id,
                    onCredit: "",
                    startingDate:
                        "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
                ;
                Get.find<HomeController>().selectedWidget.value = AllSalesPage(
                  page: "homePage",
                );
              } else {
                salesController.salesInitialIndex.value = 2;
                salesController.getSalesByShop(
                    id: shopController.currentShop.value?.id,
                    onCredit: "",
                    attendantId: "",
                    startingDate:
                        "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");
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
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: salesController.sales.length == 0
            ? 0
            : salesController.sales.length > 4
                ? 4
                : salesController.sales.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          SalesModel salesModel = salesController.sales.elementAt(index);

          return soldCard(salesModel: salesModel, context: context);
        });
  }
}
