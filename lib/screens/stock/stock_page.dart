import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/import_products.dart';
import 'package:pointify/screens/stock/stock_transfer.dart';
import 'package:pointify/screens/purchases/all_purchases.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../functions/functions.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../home/home_page.dart';
import '../product/stock_counts.dart';
import '../product/create_product.dart';
import '../product/products_page.dart';
import 'badstocks.dart';
import '../purchases/create_purchase.dart';

class StockPage extends StatelessWidget {
  // final String page;
  StockPage({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();

  List<Map<String, dynamic>> enterpriseOperations = [
    {
      "title": "Add New",
      "icon": Icons.production_quantity_limits,
      "category": "products",
      "permission": "add",
      "subtitle": "Introduce new product",
      "color": Colors.amberAccent
    },
    {
      "title": "Purchase",
      "icon": Icons.add,
      "category": "stocks",
      "permission": "add",
      "subtitle": "Add to an existing stock",
      "color": Colors.blueAccent
    },
    {
      "title": "Purchase",
      "icon": Icons.remove_red_eye_rounded,
      "category": "stocks",
      "permission": "purchases",
      "subtitle": "View purchased items",
      "color": Colors.white
    },
    {
      "title": "Count",
      "icon": Icons.calculate_outlined,
      "category": "stocks",
      "permission": "count",
      "subtitle": "Tally with physical count",
      "color": Colors.amberAccent
    },
    {
      "title": "Bad Stock",
      "icon": Icons.remove_circle_outline,
      "category": "stocks",
      "permission": "badstock",
      "subtitle": "View/Add faulty goods",
      "color": Colors.redAccent
    },
    {
      "title": "Transfer",
      "icon": Icons.compare_arrows,
      "category": "stocks",
      "permission": "transfer",
      "subtitle": "Transfer stock to  another shop",
      "color": Colors.green
    },
  ];

  @override
  Widget build(BuildContext context) {
    productController.getProductsBySort(type: "all");
    return Helper(
        widget: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (checkPermission(
                    category: "stocks", permission: "stock_summary"))
                  stockValueCard(type: "small"),
                const SizedBox(height: 10),
                majorTitle(
                    title: "Stock Actions", color: Colors.black, size: 18.0),
                Container(
                  child: isSmallScreen(context)
                      ? ListView.builder(
                          itemCount: enterpriseOperations
                              .where((e) =>
                                  checkPermission(
                                      category: e["category"],
                                      permission: e["permission"]) ==
                                  true)
                              .toList()
                              .length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (c, i) {
                            var e = enterpriseOperations.elementAt(i);
                            return stockContainers(
                                title: e["title"],
                                subtitle: e["subtitle"],
                                icon: e["icon"],
                                onPresssed: () {
                                  switch (e["subtitle"]) {
                                    case "Introduce new product":
                                      {
                                        Get.to(() => CreateProduct(
                                              page: "create",
                                              productModel: null,
                                          clearInputs: true,
                                            ));
                                      }
                                    case "Add to an existing stock":
                                      {
                                        if (shopController
                                                .checkSubscription() ==
                                            true) {
                                          Get.to(() => CreatePurchase());
                                        }
                                      }
                                    case "View purchased items":
                                      {
                                        Get.to(() => AllPurchases());
                                      }
                                    case "Tally with physical count":
                                      {
                                        if (shopController
                                                .checkSubscription() ==
                                            true) {
                                          Get.to(() => StockCount());
                                        }
                                      }
                                    case "View/Add faulty goods":
                                      {
                                        Get.to(() => BadStockPage(
                                              page: "stock",
                                            ));
                                      }
                                    case "Transfer stock to  another shop":
                                      {
                                        if (shopController
                                                .checkSubscription() ==
                                            true) {
                                          Get.to(() => StockTransfer());
                                        }
                                      }
                                  }
                                },
                                context: context,
                                color: e["color"]);
                          },
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:MediaQuery.of(context).size.width<900?1.4: 1.6,
                                  crossAxisCount: 3,
                                  crossAxisSpacing:
                                      isSmallScreen(context) ? 2 : 6,
                                  mainAxisSpacing:
                                      isSmallScreen(context) ? 10 : 3),
                          padding: EdgeInsets.zero,
                          itemCount: enterpriseOperations
                              .where((e) =>
                                  checkPermission(
                                      category: e["category"],
                                      permission: e["permission"]) ==
                                  true)
                              .toList()
                              .length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (c, i) {
                            var e = enterpriseOperations.elementAt(i);
                            return stockContainers(
                                title: e["title"],
                                subtitle: e["subtitle"],
                                icon: e["icon"],
                                onPresssed: () {
                                  switch (e["subtitle"]) {
                                    case "Introduce new product":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = CreateProduct(
                                          page: "create",
                                          productModel: null,
                                          clearInputs: true,
                                        );
                                      }
                                    case "Add to an existing stock":
                                      {
                                        if (shopController
                                                .checkSubscription() ==
                                            true) {
                                          Get.find<HomeController>()
                                              .selectedWidget
                                              .value = CreatePurchase();
                                        }
                                      }
                                    case "View purchased items":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = AllPurchases();
                                      }
                                    case "Tally with physical count":
                                      {
                                        if (shopController
                                                .checkSubscription() ==
                                            true) {
                                          Get.find<HomeController>()
                                              .selectedWidget
                                              .value = StockCount();
                                        }
                                      }
                                    case "View/Add faulty goods":
                                      {
                                        Get.find<HomeController>()
                                            .selectedWidget
                                            .value = BadStockPage(
                                          page: "stock",
                                        );
                                      }
                                    case "Transfer stock to  another shop":
                                      {
                                        if (shopController
                                                .checkSubscription() ==
                                            true) {
                                          Get.find<HomeController>()
                                              .selectedWidget
                                              .value = StockTransfer();
                                        }
                                      }
                                  }
                                },
                                context: context,
                                color: e["color"]);
                          },
                        ),
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          elevation: 0.3,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              if (isSmallScreen(context)) {
                Get.back();
              } else {
                Get.find<HomeController>().selectedWidget.value = HomePage();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(title: "Stock", color: Colors.black, size: 16.0),
              minorTitle(
                  title: "${shopController.currentShop.value?.name}",
                  color: Colors.grey)
            ],
          ),
        ));
  }

  Widget stockContainers(
      {required title,
      required subtitle,
      required icon,
      required onPresssed,
      required context,
      required Color color}) {
    return InkWell(
      onTap: () {
        onPresssed();
      },
      child: Container(
        width: isSmallScreen(Get.context)
            ? MediaQuery.of(context).size.width
            : 200,
        margin: EdgeInsets.only(
            top: 10, right: isSmallScreen(Get.context) ? 0 : 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: isSmallScreen(Get.context)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  iconWidget(color: color, icon: icon),
                  const SizedBox(
                    width: 10,
                  ),
                  content(title: title, subtitle: subtitle),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconWidget(color: color, icon: icon),
                  const SizedBox(
                    height: 10,
                  ),
                  content(title: title, subtitle: subtitle),
                ],
              ),
      ),
    );
  }

  Widget iconWidget({required color, required icon}) {
    double size = isSmallScreen(Get.context) ? 40 : 80;
    return Container(
      height: size,
      width: size,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Center(child: Icon(icon)),
    );
  }

  Widget content({required title, required subtitle}) {
    return Column(
      crossAxisAlignment: isSmallScreen(Get.context)
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        majorTitle(title: title, color: Colors.black, size: 16.0),
        const SizedBox(height: 5),
        normalText(title: subtitle, color: Colors.grey, size: 14.0)
      ],
    );
  }

  Widget stockValueCard({required String type}) {
    return Card(
      elevation: 5,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                majorTitle(
                    title: "Stock Value", color: Colors.black, size: 15.0),
                const Spacer(),
                Obx(() {
                  return normalText(
                      title: htmlPrice(productController.stockValue.value),
                      color: Colors.black,
                      size: 14.0);
                })
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                majorTitle(
                    title: "Profit Estimate", color: Colors.black, size: 15.0),
                const Spacer(),
                Obx(() {
                  return normalText(
                      title: htmlPrice(
                          productController.totalProfitEstimate.value),
                      color: Colors.black,
                      size: 14.0);
                })
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                majorTitle(
                    title: "Product Variance", color: Colors.black, size: 15.0),
                const Spacer(),
                Obx(() {
                  return minorTitle(
                      title: "${productController.products.length}",
                      color: Colors.black);
                })
              ],
            ),
            const SizedBox(height: 20),
            if (checkPermission(category: "stocks", permission: "view"))
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (isSmallScreen(Get.context)) {
                    Get.to(() => ProductPage());
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        ProductPage();
                  }
                },
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: isSmallScreen(Get.context) ? double.infinity : 200,
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 3, color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                        child: majorTitle(
                            title: "View Products",
                            color: AppColors.mainColor,
                            size: 18.0)),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                if (isSmallScreen(Get.context)) {
                  Get.to(() => const ImportProducts());
                } else {
                  Get.find<HomeController>().selectedWidget.value =
                      const ImportProducts();
                }
              },
              child: Center(
                child: Center(
                    child: majorTitle(
                        title: "Import Products",
                        color: AppColors.mainColor,
                        size: 13.0)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
