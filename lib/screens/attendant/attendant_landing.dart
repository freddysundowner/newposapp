// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterpos/screens/product/counting_page.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../models/product_model.dart';
import '../../utils/colors.dart';
import '../finance/expense_page.dart';
import '../product/create_product.dart';
import '../stock/create_purchase.dart';

class AttendantLanding extends StatelessWidget {
  AttendantLanding({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();

  Future<void> _refreshUser() async {
    await attendantController
        .getAttendantsById(attendantController.attendant.value!.id);
  }

  List<String> roles = [
    "sales",
    "stockin",
    "add_products",
    "expenses",
    "stock_balance",
    "count_stock",
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshUser,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
            elevation: 0.0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.mainColor,
            title: Obx(() {
              return Text(
                attendantController.attendant.value!.shop == null
                    ? ""
                    : "${attendantController.attendant.value!.shop!.name}"
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Welcome ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                Obx(() {
                  return Text(
                    "${attendantController.attendant.value!.fullnames}"
                        .capitalize!,
                    style: TextStyle(
                        color: Colors.amber, fontWeight: FontWeight.bold),
                  );
                })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("AttendantID:", style: TextStyle(color: Colors.grey)),
                Obx(() {
                  return Text(
                    "${attendantController.attendant.value!.attendid}",
                    style: TextStyle(color: Colors.grey),
                  );
                })
              ],
            ),
            SizedBox(height: 5),
            Expanded(
              child: Obx(
                () => ListView(
                  children: attendantController.attendant.value!.roles == null
                      ? []
                      : attendantController.attendant.value!.roles!
                          .where((e) =>
                              roles.indexWhere((element) => element == e.key) !=
                              -1)
                          .map((e) => Container(
                                margin: EdgeInsets.only(bottom: 20),
                                child: InkWell(
                                  onTap: () {
                                    if (e.key == "expenses") {
                                      Get.to(() => ExpensePage());
                                    } else if (e.key == "add_products") {
                                      Get.to(() => CreateProduct(
                                          page: "create",
                                          productModel: ProductModel()));
                                    } else if (e.key == "sales") {
                                      Get.to(() => CreateSale());
                                    } else if (e.key == "stockin") {
                                      Get.to(CreatePurchase());
                                    } else if (e.key ==
                                        "canviewstockbalanceList") {
                                      // Get.to(() => ViewOtherShop());

                                    } else if (e.key == "count_stock") {
                                      Get.to(() => CountingPage());
                                    }
                                  },
                                  child: Center(
                                    child: Material(
                                      elevation: 10,
                                      color: Colors.transparent,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
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
            InkWell(
              onTap: () {
                // Get.to(CustomCalculator());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calculate,
                    color: Colors.grey,
                    size: 14,
                  ),
                  SizedBox(width: 2),
                  Text(
                    "Calculator",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
