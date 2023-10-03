import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/products_page.dart';
import 'package:get/get.dart';
import 'package:pointify/screens/product/tabs/bad_stock_history.dart';
import 'package:pointify/screens/product/tabs/product_sales.dart';
import 'package:pointify/screens/product/tabs/stockin_history.dart';
import 'package:pointify/screens/product/tabs/count_history.dart';
import 'package:pointify/utils/colors.dart';

import '../../Real/schema.dart';
import '../../controllers/stock_transfer_controller.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/tab_view.dart';

class ProductHistory extends StatelessWidget {
  final Product product;

  ProductHistory({Key? key, required this.product}) : super(key: key);

  StockTransferController stockTransferController =
      Get.find<StockTransferController>();
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();

  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0.0,
          backgroundColor:
              isSmallScreen(context) ? AppColors.mainColor : Colors.white,
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                if (!isSmallScreen(context)) {
                  Get.find<HomeController>().selectedWidget.value =
                      ProductPage();
                } else {
                  Get.back();
                }
              },
              icon: Icon(Icons.arrow_back_ios,
                  color: isSmallScreen(context) ? Colors.white : Colors.black)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${product.name!}",
                style: TextStyle(
                    fontSize: 16,
                    color:
                        isSmallScreen(context) ? Colors.white : Colors.black),
              ),
              minorTitle(
                  title: "History",
                  color: isSmallScreen(context) ? Colors.white : Colors.black),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.white,
                        child: ListView.builder(
                            itemCount: getYears(2019).length,
                            itemBuilder: (c, i) {
                              var year = getYears(2019)[i];
                              return InkWell(
                                onTap: () {
                                  productController.currentYear.value = year;
                                  salesController.currentYear.value = year;
                                  getYearlyRecords(product, function:
                                      (Product p, DateTime firstDayofYear,
                                          DateTime lastDayofYear) {
                                    salesController.getSalesByProductId(
                                        product: p,
                                        fromDate: firstDayofYear,
                                        toDate: lastDayofYear);

                                    productController.getProductPurchaseHistory(
                                        p,
                                        fromDate: firstDayofYear,
                                        toDate: lastDayofYear);

                                    productController.getBadStock(
                                        product: p,
                                        fromDate: firstDayofYear,
                                        toDate: lastDayofYear);
                                  }, year: year);
                                  Get.back();
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        year.toString().capitalize!,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    Divider()
                                  ],
                                ),
                              );
                            }),
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Obx(() => Text(
                          productController.currentYear.value.toString(),
                          style: TextStyle(
                              color: isSmallScreen(context)
                                  ? Colors.white
                                  : Colors.black),
                        )),
                    Icon(Icons.arrow_drop_down,
                        color: isSmallScreen(context)
                            ? Colors.white
                            : Colors.black)
                  ],
                ),
              ),
            )
          ],
        ),
        body: DefaultTabController(
            initialIndex: 0,
            length: 4,
            child: Builder(builder: (context) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => TabBar(
                        controller: DefaultTabController.of(context),
                        onTap: (index) {
                          productController.productHistoryTabIndex.value =
                              index;
                          getYearlyRecords(product, function: (Product p,
                              DateTime firstDayofYear, DateTime lastDayofYear) {
                            if (index == 0) {
                              salesController.getSalesByProductId(
                                  product: product,
                                  fromDate: firstDayofYear,
                                  toDate: lastDayofYear);
                            }
                            if (index == 1) {
                              productController.getProductPurchaseHistory(
                                  product,
                                  fromDate: firstDayofYear,
                                  toDate: lastDayofYear);
                            }
                            if (index == 2) {
                              productController.getBadStock(
                                  fromDate: firstDayofYear,
                                  toDate: lastDayofYear,
                                  product: product);
                            }
                            if (index == 3) {
                              productController.getCountHistory(
                                  product: product);
                            }
                          }, year: productController.currentYear.value);
                        },
                        tabs: [
                          Tab(
                            child: tabView(
                                title: "Sales",
                                subtitle: htmlPrice(salesController.productSales
                                    .fold(
                                        0,
                                        (previousValue, element) =>
                                            previousValue + element.total!))),
                          ),
                          Tab(
                              child: tabView(
                                  title: "IN",
                                  subtitle: htmlPrice(
                                      productController.productInvoices.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              element.total!)))),
                          Tab(
                              child: tabView(
                                  title: "Bad",
                                  subtitle: htmlPrice(
                                      productController.badstocks.fold(
                                          0,
                                          (previousValue, element) =>
                                              previousValue +
                                              (element.quantity! *
                                                  element.product!
                                                      .buyingPrice!))))),
                          Tab(
                              child:
                                  tabView(title: "Count", subtitle: "History")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TabBarView(
                            controller: DefaultTabController.of(context),
                            children: [
                              SalesPages(
                                product: product,
                              ),
                              ProductStockInHistory(
                                product: product,
                              ),
                              ProductBadStcokHistory(
                                product: product,
                              ),
                              ProductCountHistory(),
                            ]),
                      ),
                    )
                  ]);
            })));
  }
}
