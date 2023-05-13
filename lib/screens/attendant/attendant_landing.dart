// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/models/roles_model.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/customers_page.dart';
import 'package:pointify/screens/product/counting_page.dart';
import 'package:pointify/screens/product/products_page.dart';
import 'package:pointify/screens/sales/all_sales_page.dart';
import 'package:pointify/screens/shop/other_shop.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
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
                          width: 60,
                          height: 60,
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
                          children: attendantController.attendant.value
                                      ?.getDisplayRoles() ==
                                  null
                              ? []
                              : attendantController.attendant.value!
                                  .getDisplayRoles()!
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
                    backgroundColor: Colors.white,
                    title: Obx(() {
                      return Text(
                        attendantController.attendant.value?.shop == null
                            ? ""
                            : "${attendantController.attendant.value?.shop!.name}"
                                .capitalize!,
                        style: TextStyle(
                          color: AppColors.mainColor,
                        ),
                      );
                    }),
                    actions: [
                      IconButton(
                        onPressed: () {
                          _refreshUser();
                        },
                        icon: Icon(
                          Icons.refresh_outlined,
                          color: AppColors.mainColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          authController.logout();
                        },
                        icon: Icon(
                          Icons.logout_outlined,
                          color: Colors.redAccent,
                        ),
                      ),
                    ]),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
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
                        child: Obx(() => Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 8,
                                          childAspectRatio: 1.4),
                                  itemCount: attendantController
                                      .attendant.value!
                                      .getDisplayRoles()
                                      ?.length,
                                  itemBuilder: (context, index) {
                                    RolesModel e = attendantController
                                        .attendant.value!
                                        .getDisplayRoles()![index];
                                    return InkWell(
                                      onTap: () {
                                        if (e.key == "expenses") {
                                          Get.to(() => ExpensePage());
                                        } else if (e.key == "add_products") {
                                          Get.to(() => ProductPage());
                                        } else if (e.key == "sales") {
                                          Get.to(() => AllSalesPage(
                                              page: "AtedantLanding"));
                                        } else if (e.key == "stockin") {
                                          Get.to(() => ViewPurchases());
                                        } else if (e.key == "customers") {
                                          Get.to(CustomersPage());
                                        } else if (e.key == "Suppliers") {
                                          Get.to(SuppliersPage());
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
                                            height: 100,
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: setColor(index),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(width: 5),
                                                Text(
                                                  e.name.capitalize!,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            )))
                  ],
                ))));
  }

  Color? setColor(int index) {
    return index.isEven ? AppColors.mainColor : Color(0xFF9575CD);
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Obx(() {
          return Text(
            "Welcome ${attendantController.attendant.value?.fullnames}"
                .capitalize!,
            style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          );
        }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ID:", style: TextStyle(color: Colors.grey)),
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
            if (title.toString().trim() == "sales") {
              homeController.selectedWidget.value =
                  AllSalesPage(page: "AttendantLanding");
            } else if (title.toString().trim() == "Stockin") {
              homeController.selectedWidget.value = ViewPurchases();
            } else if (title.toString().trim() == "Manage Customers") {
              homeController.selectedWidget.value = CustomersPage();
            } else if (title.toString().trim() == "Manage suppliers") {
              homeController.selectedWidget.value = SuppliersPage();
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
