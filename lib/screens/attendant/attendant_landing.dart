// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/customers_page.dart';
import 'package:flutterpos/screens/product/counting_page.dart';
import 'package:flutterpos/screens/product/products_page.dart';
import 'package:flutterpos/screens/sales/all_sales_page.dart';
import 'package:flutterpos/screens/shop/other_shop.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../finance/expense_page.dart';
import '../stock/view_purchases.dart';

class AttendantLanding extends StatelessWidget {
  AttendantLanding({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();
  HomeController homeController = Get.find<HomeController>();

  Future<void> _refreshUser() async {
    await attendantController
        .getAttendantsById(attendantController.attendant.value!.id);
  }

  List<String> roles = [
    "sales",
    "stockin",
    "customers",
    "Suppliers",
    "add_products",
    "expenses",
    "stock_balance",
    "count_stock",
  ];

  @override
  Widget build(BuildContext context) {
    homeController.selectedWidget.value =
        Container(child: noItemsFound(context, true));
    return ResponsiveWidget(
        largeScreen: Obx(() => Scaffold(
            backgroundColor: Colors.white,
            appBar: top_appbar(),
            body: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey.withOpacity(0.3),
                    padding: EdgeInsets.only(top: 10, left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white, width: 4),
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"))),
                        ),
                        SizedBox(height: 15),
                        attendantDetails(context),
                        SizedBox(height: 15),
                        ListView(
                          shrinkWrap: true,
                          children:
                              attendantController.attendant.value?.roles == null
                                  ? []
                                  : attendantController.attendant.value!.roles!
                                      .where((e) =>
                                          roles.indexWhere(
                                              (element) => element == e.key) !=
                                          -1)
                                      .map((e) => sideMenu(e.name))
                                      .toList(),
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            authController.logout();
                          },
                          child: majorTitle(
                              title: "Logout", color: Colors.black, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(flex: 4, child: homeController.selectedWidget.value!)
              ],
            ))),
        smallScreen: RefreshIndicator(
          onRefresh: _refreshUser,
          child: Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
                elevation: 0.0,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.mainColor,
                title: Obx(() {
                  return Text(
                    attendantController.attendant.value?.shop == null
                        ? ""
                        : "${attendantController.attendant.value?.shop!.name}"
                            .capitalize!,
                    style: TextStyle(color: Colors.white),
                  );
                }),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await attendantController.getAttendantsById(
                          attendantController.attendant.value!.id);
                    },
                    icon: Icon(
                      Icons.refresh_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      authController.logout();
                    },
                    icon: Icon(
                      Icons.logout_outlined,
                      color: Colors.white,
                    ),
                  ),
                ]),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 4),
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__340.png"))),
                  ),
                ),
                SizedBox(height: 15),
                attendantDetails(context),
                SizedBox(height: 5),
                Expanded(
                  child: Obx(
                    () => ListView(
                      children: attendantController.attendant.value?.roles ==
                              null
                          ? []
                          : attendantController.attendant.value!.roles!
                              .where((e) =>
                                  roles.indexWhere(
                                      (element) => element == e.key) !=
                                  -1)
                              .map((e) => Container(
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: InkWell(
                                      onTap: () {
                                        if (e.key == "expenses") {
                                          Get.to(() => ExpensePage());
                                        } else if (e.key == "add_products") {
                                          // Get.to(() => CreateProduct(page: "create",productModel: ProductModel()));
                                          Get.to(() => ProductPage());
                                        } else if (e.key == "sales") {
                                          // Get.to(() => CreateSale());
                                          Get.to(() => AllSalesPage(
                                              page: "AtedantLanding"));
                                        } else if (e.key == "stockin") {
                                          // Get.to(CreatePurchase());
                                          Get.to(() => ViewPurchases());
                                        } else if (e.key == "customers") {
                                          Get.to(
                                              CustomersPage(type: "customers"));
                                        } else if (e.key == "Suppliers") {
                                          Get.to(
                                              CustomersPage(type: "supplier"));
                                        } else if (e.key == "stock_balance") {
                                          Get.to(() => ViewOtherShop());
                                        } else if (e.key == "count_stock") {
                                          Get.to(() => CountingPage());
                                        }
                                      },
                                      child: Center(
                                        child: Material(
                                          elevation: 10,
                                          color: Colors.transparent,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(Icons.production_quantity_limits,
                                                //     color: Colors.white),
                                                SizedBox(width: 5),
                                                Text(
                                                  e.name,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  AppBar top_appbar() {
    return AppBar(
      titleSpacing: 0.0,
      leading: Icon(
        Icons.electric_bolt,
        color: AppColors.mainColor,
      ),
      title:
          majorTitle(title: "Store Attendant", color: Colors.black, size: 16.0),
      elevation: 0.2,
      backgroundColor: Colors.white,
    );
  }

  Widget attendantDetails(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MediaQuery.of(context).size.width > 600
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: MediaQuery.of(context).size.width > 600
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.center,
          children: [
            Text("Welcome ",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            Obx(() {
              return Text(
                "${attendantController.attendant.value?.fullnames}".capitalize!,
                style:
                    TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              );
            })
          ],
        ),
        Row(
          mainAxisAlignment: MediaQuery.of(context).size.width > 600
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          crossAxisAlignment: MediaQuery.of(context).size.width > 600
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.center,
          children: [
            Text("AttendantID:", style: TextStyle(color: Colors.grey)),
            Obx(() {
              return Text(
                "${attendantController.attendant.value?.attendid}",
                style: TextStyle(color: Colors.grey),
              );
            })
          ],
        ),
      ],
    );
  }

  Widget sideMenu(title) {
    return Obx(() => InkWell(
          onTap: () {
            attendantController.activeItem.value = title;
            print(title);
            if (title.toString().trim() == "sales") {
              homeController.selectedWidget.value =
                  AllSalesPage(page: "AttendantLanding");
            } else if (title.toString().trim() == "Stockin") {
              homeController.selectedWidget.value = ViewPurchases();
            } else if (title.toString().trim() == "Manage Customers") {
              homeController.selectedWidget.value =
                  CustomersPage(type: "customers");
            } else if (title.toString().trim() == "Manage suppliers") {
              homeController.selectedWidget.value =
                  CustomersPage(type: "suppliers");
            } else if (title.toString().trim() == "Add products") {
              homeController.selectedWidget.value = ProductPage();
            } else if (title.toString().trim() == "Add expenses") {
              homeController.selectedWidget.value = ExpensePage();
            } else if (title.toString().trim() == "Stock balance") {
              homeController.selectedWidget.value = ViewOtherShop();
            } else if (title.toString().trim() == "Count stock") {
              homeController.selectedWidget.value = CountingPage();
            }
          },
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "${title}".capitalize!,
              style: TextStyle(
                  color: attendantController.activeItem.value == title
                      ? AppColors.mainColor
                      : Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ));
  }
}
