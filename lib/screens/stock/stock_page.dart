import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/responsive/large_screen.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/stock/stock_transfer.dart';
import 'package:flutterpos/screens/stock/view_purchases.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/normal_text.dart';
import '../../widgets/smalltext.dart';
import '../product/counting_page.dart';
import '../product/create_product.dart';
import '../product/products_page.dart';
import 'create_purchase.dart';

class StockPage extends StatelessWidget {
  StockPage({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    productController.getProductsBySort(
        shopId: "${shopController.currentShop.value?.id}", type: "all");
    return ResponsiveWidget(
        largeScreen: Container(
          padding: EdgeInsets.all(20),
          child: Scaffold(
            body: LargeScreen(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: stockValueCard(type: "large"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  majorTitle(
                      title: "Stock Actions", color: Colors.black, size: 18.0),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,

                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: stockContainerDesktop(
                              title: "Add New",
                              subtitle: "Introduce new product",
                              icon: Icons.production_quantity_limits,
                              onPresssed: () {
                                Get.to(() => CreateProduct(
                                      page: "create",
                                      productModel: ProductModel(),
                                    ));
                              },
                              color: Colors.amberAccent),
                        ),
                        stockContainerDesktop(
                            title: "Purchase",
                            subtitle: "Add to an existing stock",
                            icon: Icons.add,
                            onPresssed: () {
                              Get.to(() => CreatePurchase());
                            },
                            color: Colors.blueAccent),
                        stockContainerDesktop(
                            title: "Purchase",
                            subtitle: "View purchased items",
                            icon: Icons.remove_red_eye_rounded,
                            onPresssed: () {
                              Get.to(() => ViewPurchases());
                            },
                            color: Colors.white),
                        stockContainerDesktop(
                            title: "Count ",
                            subtitle: "Tally with physical count",
                            icon: Icons.calculate_outlined,
                            onPresssed: () {
                              Get.to(() => CountingPage());
                            },
                            color: Colors.amberAccent),
                        stockContainerDesktop(
                            title: "Transfer",
                            subtitle: "Transfer stock to  another shop",
                            icon: Icons.compare_arrows,
                            onPresssed: () {
                              Get.to(() => StockTransfer());
                            },
                            color: Colors.green)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        smallScreen: Helper(
            widget: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    stockValueCard(type: "small"),
                    SizedBox(height: 10),
                    majorTitle(
                        title: "Stock Actions",
                        color: Colors.black,
                        size: 18.0),
                    stockContainers(
                        title: "Add New",
                        subtitle: "Introduce new product",
                        icon: Icons.production_quantity_limits,
                        onPresssed: () {
                          Get.to(() => CreateProduct(
                                page: "create",
                                productModel: ProductModel(),
                              ));
                        },
                        color: Colors.amberAccent),
                    stockContainers(
                        title: "Purchase",
                        subtitle: "Add to an existing stock",
                        icon: Icons.add,
                        onPresssed: () {
                          Get.to(() => CreatePurchase());
                        },
                        color: Colors.blueAccent),
                    stockContainers(
                        title: "Purchase",
                        subtitle: "View purchased items",
                        icon: Icons.remove_red_eye_rounded,
                        onPresssed: () {
                          Get.to(() => ViewPurchases());
                        },
                        color: Colors.white),
                    stockContainers(
                        title: "Count ",
                        subtitle: "Tally with physical count",
                        icon: Icons.calculate_outlined,
                        onPresssed: () {
                          Get.to(() => CountingPage());
                        },
                        color: Colors.amberAccent),
                    stockContainers(
                        title: "Transfer",
                        subtitle: "Transfer stock to  another shop",
                        icon: Icons.compare_arrows,
                        onPresssed: () {
                          Get.to(() => StockTransfer());
                        },
                        color: Colors.green)
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
                  Get.back();
                },
                icon: Icon(
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
            )));
  }

  Widget stockContainers(
      {required title,
      required subtitle,
      required icon,
      required onPresssed,
      required Color color}) {
    return InkWell(
      onTap: () {
        onPresssed();
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Center(child: Icon(icon)),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                majorTitle(title: title, color: Colors.black, size: 16.0),
                SizedBox(height: 5),
                normalText(title: subtitle, color: Colors.grey, size: 14.0)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget stockContainerDesktop(
      {required title,
      required subtitle,
      required icon,
      required onPresssed,
      required Color color}) {
    return InkWell(
      onTap: () {
        onPresssed();
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, right: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              child: Center(child: Icon(icon)),
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(20)),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                majorTitle(title: title, color: Colors.black, size: 16.0),
                SizedBox(height: 5),
                normalText(title: subtitle, color: Colors.grey, size: 14.0)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget stockValueCard({required String type}) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                majorTitle(
                    title: "Stock Value", color: Colors.black, size: 15.0),
                Spacer(),
                Obx(() {
                  return normalText(
                      title:
                          "${shopController.currentShop.value?.currency}.${productController.totalSale.value}",
                      color: Colors.black,
                      size: 14.0);
                })
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                majorTitle(
                    title: "Profit Estimate", color: Colors.black, size: 15.0),
                Spacer(),
                Obx(() {
                  return normalText(
                      title:
                          "${shopController.currentShop.value?.currency}.${productController.totalProfit.value}",
                      color: Colors.black,
                      size: 14.0);
                })
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                majorTitle(
                    title: "Product Variance", color: Colors.black, size: 15.0),
                Spacer(),
                Obx(() {
                  return minorTitle(
                      title: "${productController.products.length}",
                      color: Colors.black);
                })
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Get.to(() => ProductPage());
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width:type=="small"? double.infinity:200,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: majorTitle(
                          title: "View Products",
                          color: AppColors.mainColor,
                          size: 18.0)),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
