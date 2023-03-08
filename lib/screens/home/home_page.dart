import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';

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
  HomePage({Key? key}) : super(key: key) {
    salesController.getSalesByDates(
        shopId: shopController.currentShop.value?.id,
        startingDate: DateTime.now(),
        endingDate: DateTime.now(),
        type: "notcashflow");
  }

  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.put(SalesController());
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Container(
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
                        border:
                            Border.all(color: AppColors.mainColor, width: 2),
                      ),
                      child: minorTitle(
                          title: "Change Shop", color: AppColors.mainColor),
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
                              Get.to(() => CreateSale());
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
                              Get.to(() => FinancePage());
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
                                Get.to(() => StockPage());
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
                              Get.to(() => CustomersPage(type: "suppliers"));
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
                                Get.to(() => CustomersPage(type: "customers"));
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
                    majorTitle(title: "Sales", color: Colors.black, size: 20.0),
                    salesController.sales.length == 0
                        ? Container()
                        : InkWell(
                            onTap: () {
                              salesController.activeItem.value = "All Sales";
                              salesController.getSalesByShop(
                                  id: shopController.currentShop.value?.id);
                              Get.to(() => AllSalesPage());
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
                return salesController.todaySalesLoad.value
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
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: double.infinity,
                            child: salesListView(isSmallScreen: false));
              }),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        smallScreen: Scaffold(
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
                          border:
                              Border.all(color: AppColors.mainColor, width: 2),
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
                            Get.to(() => CustomersPage(type: "suppliers"));
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
                          Get.to(() => AllSalesPage());
                        },
                        child: minorTitle(
                            title: "See all", color: AppColors.lightDeepPurple))
                  ],
                ),
                SizedBox(height: 10),
                Obx(() {
                  return salesController.getSalesByDateLoad.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : salesListView(isSmallScreen: true);
                })
              ],
            ),
          ),
        )));
  }

  showShopModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
              itemCount: shopController.AdminShops.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                ShopModel shopBody = shopController.AdminShops.elementAt(index);
                return InkWell(
                  onTap: () {
                    Get.back();
                    shopController.currentShop.value = shopBody;
                    salesController.getSalesByDates(
                        shopId: shopController.currentShop.value?.id,
                        startingDate: DateTime.now(),
                        endingDate: DateTime.now(),
                        type: "notcashflow");
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: majorTitle(
                        title: "${shopBody.name}",
                        color: Colors.black,
                        size: 16.0),
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
                return salesController.getSalesByDateLoad.value
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
                salesController.activeItem.value = "Today";
                salesController.getSalesByDates(
                    shopId: shopController.currentShop.value?.id,
                    startingDate: DateTime.now(),
                    endingDate: DateTime.now(),
                    type: "notcashflow");
              } else {
                salesController.salesInitialIndex.value = 2;
                salesController.getSalesByDates(
                    shopId: shopController.currentShop.value?.id,
                    startingDate: DateTime.now(),
                    endingDate: DateTime.now(),
                    type: "notcashflow");
              }
              Get.to(() => AllSalesPage());
            },
            child:
                majorTitle(title: "View More", color: Colors.white, size: 18.0),
          ),
        ],
      ),
    );
  }

  Widget salesListView({required bool isSmallScreen}) {
    return ListView.builder(
        physics: isSmallScreen == true
            ? NeverScrollableScrollPhysics()
            : ScrollPhysics(),
        itemCount: salesController.sales.length == 0
            ? 0
            : isSmallScreen
                ? salesController.sales.length > 4
                    ? 4
                    : salesController.sales.length
                : salesController.sales.length > 10
                    ? 10
                    : salesController.sales.length,
        shrinkWrap: true,
        scrollDirection: isSmallScreen ? Axis.vertical : Axis.horizontal,
        itemBuilder: (context, index) {
          SalesModel salesModel = salesController.sales.elementAt(index);

          return soldCard(salesModel: salesModel, context: context);
        });
  }
}
