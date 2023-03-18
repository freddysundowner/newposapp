import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/screens/product/products_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/product_history_controller.dart';
import '../../models/product_history_model.dart';
import '../../models/product_sales_history.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class ProductHistory extends StatelessWidget {
  final ProductModel product;

  ProductHistory({Key? key, required this.product}) : super(key: key);
  ProductHistoryController productHistoryController =
      Get.find<ProductHistoryController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0.0,
          centerTitle: false,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      ProductPage();
                } else {
                  Get.back();
                }
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: "${product.name!}", color: Colors.black, size: 16.0),
              minorTitle(title: "History", color: Colors.grey),
            ],
          ),
        ),
        body: Column(children: [
          Container(
            color: Colors.white,
            height: kToolbarHeight,
            child: TabBar(
              indicatorColor: AppColors.mainColor,
              indicatorWeight: 3,
              controller: productHistoryController.tabController,
              labelColor: AppColors.mainColor,
              unselectedLabelColor: Colors.black,
              onTap: (index) {
                if (index == 0) {
                  productHistoryController.getProductHistory(
                      productId: product.id, type: "sold");
                }
                if (index == 1) {
                  productHistoryController.getProductHistory(
                      productId: product.id, type: "purchase");
                }
                if (index == 2) {
                  productHistoryController.getProductHistory(
                      productId: product.id, type: "transfer");
                }
                if (index == 3) {
                  productHistoryController.getProductHistory(
                      productId: product.id, type: "badstock");
                }
                productHistoryController.changeTabIndex(index);
              },
              tabs: productHistoryController.tabs,
            ),
          ),
          Expanded(
            child: Container(
              color: MediaQuery.of(context).size.width > 600
                  ? Colors.white
                  : Colors.grey.withOpacity(0.3),
              child: TabBarView(
                  controller: productHistoryController.tabController,
                  children: [
                    SalesPages(
                        productHistoryController: productHistoryController,
                        productId: product.id,
                        type: "cash"),
                    HistoryPages(
                        productHistoryController: productHistoryController,
                        productId: product.id,
                        type: "purchase"),
                    HistoryPages(
                        productHistoryController: productHistoryController,
                        productId: product.id,
                        type: "transfer"),
                    HistoryPages(
                      productHistoryController: productHistoryController,
                      productId: product.id,
                      type: "badstock",
                    ),
                  ]),
            ),
          )
        ]));
  }
}

class HistoryPages extends StatelessWidget {
  final type;
  final ProductHistoryController productHistoryController;
  final productId;

  HistoryPages(
      {Key? key,
      required this.productHistoryController,
      required this.productId,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return productHistoryController.gettingHistoryLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productHistoryController.product.length == 0
              ? Center(
                  child: Text("There are no iems to display"),
                )
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.grey),
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 20),
                              child: DataTable(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                  width: 1,
                                  color: Colors.black,
                                )),
                                columnSpacing: 30.0,
                                columns: [
                                  DataColumn(
                                      label: Text('Product',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Quantity',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Buying Price',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Selling Price',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Date',
                                          textAlign: TextAlign.center)),
                                ],
                                rows: List.generate(
                                    productHistoryController.product.length,
                                    (index) {
                                  ProductHistoryModel productBody =
                                      productHistoryController.product
                                          .elementAt(index);
                                  final y = productBody.product!.name;
                                  final x = productBody.quantity;
                                  final w = productBody.product!.buyingPrice;
                                  final z =
                                      productBody.product!.sellingPrice![0];
                                  final a = productBody.createdAt;

                                  return DataRow(cells: [
                                    DataCell(
                                        Container(width: 75, child: Text(y!))),
                                    DataCell(Container(
                                        width: 75, child: Text(x.toString()))),
                                    DataCell(Container(
                                        width: 75, child: Text(w.toString()))),
                                    DataCell(Container(
                                        width: 75, child: Text(z.toString()))),
                                    DataCell(Container(
                                        width: 75,
                                        child: Text(DateFormat("dd-MM-yyyy")
                                            .format(a!)))),
                                  ]);
                                }),
                              ),
                            ),
                          ),
                          SizedBox(height: 30)
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: productHistoryController.product.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ProductHistoryModel productBody =
                            productHistoryController.product.elementAt(index);

                        return productHistoryContainer(productBody);
                      });
    });
  }

  Widget productHistoryContainer(ProductHistoryModel productBody) {
    ShopController shopController = Get.find<ShopController>();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.product!.name}".capitalize!,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      // Text(
                      //   "${productBody.product!.category ?? ""}",
                      //   style: TextStyle(color: Colors.grey, fontSize: 16),
                      // ),
                      Text('Qty ${productBody.quantity}'),
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                    ],
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                      'BP/=  ${shopController.currentShop.value?.currency}.${productBody.product!.buyingPrice}'),
                  Text(
                      'SP/=  ${shopController.currentShop.value?.currency}.${productBody.product!.sellingPrice![0]}')
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}

class SalesPages extends StatelessWidget {
  final type;
  final ProductHistoryController productHistoryController;
  final productId;

  SalesPages(
      {Key? key,
      required this.productHistoryController,
      required this.productId,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    productHistoryController.getHistory(productId: productId);

    return Obx(() {
      return productHistoryController.loadingSalesHistory.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productHistoryController.salesHistory.length == 0
              ? Center(
                  child: Text("There are no iems to display"),
                )
              : MediaQuery.of(context).size.width > 600
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.grey),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                                right: 15, left: 15, bottom: 20),
                            child: DataTable(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.black,
                              )),
                              columnSpacing: 30.0,
                              columns: [
                                DataColumn(
                                    label: Text('Product',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Quantity',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Buying Price',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Selling Price',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Date',
                                        textAlign: TextAlign.center)),
                              ],
                              rows: List.generate(
                                  productHistoryController.salesHistory.length,
                                  (index) {
                                ProductSaleHistory productBody =
                                    productHistoryController.salesHistory
                                        .elementAt(index);
                                final y = productBody.product!.name;
                                final x = productBody.quantity;
                                final w = productBody.product!.buyingPrice;
                                final z = productBody.product!.sellingPrice![0];
                                final a = productBody.createdAt;

                                return DataRow(cells: [
                                  DataCell(
                                      Container(width: 75, child: Text(y!))),
                                  DataCell(Container(
                                      width: 75, child: Text(x.toString()))),
                                  DataCell(Container(
                                      width: 75, child: Text(w.toString()))),
                                  DataCell(Container(
                                      width: 75, child: Text(z.toString()))),
                                  DataCell(Container(
                                      width: 75,
                                      child: Text(
                                          DateFormat("yyyy-dd-MM hh:mm a")
                                              .format(a!)))),
                                ]);
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 30)
                      ],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: productHistoryController.salesHistory.length,
                      itemBuilder: (context, index) {
                        ProductSaleHistory productBody =
                            productHistoryController.salesHistory
                                .elementAt(index);

                        return productHistoryContainer(productBody);
                      });
    });
  }

  Widget productHistoryContainer(ProductSaleHistory productBody) {
    ShopController shopController = Get.find<ShopController>();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.product!.name}".capitalize!,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "${productBody.product!.category}",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text('Qty ${productBody.itemCount}'),
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                    ],
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                      'BP/= ${shopController.currentShop.value?.currency}.${productBody.product!.buyingPrice}'),
                  Text(
                      'SP/=  ${shopController.currentShop.value?.currency}.${productBody.total}')
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
