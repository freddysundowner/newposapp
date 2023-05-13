import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/screens/product/products_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/product_history_controller.dart';
import '../../models/badstock.dart';
import '../../models/invoice_items.dart';
import '../../models/productTransfer.dart';
import '../../models/product_history_model.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import 'components/product_history_card.dart';

class ProductHistory extends StatelessWidget {
  final ProductModel product;

  ProductHistory({Key? key, required this.product}) : super(key: key) {
    productHistoryController.product.clear();
    salesController.getSalesBySaleId(productId: product.id);
  }

  ProductHistoryController productHistoryController =
      Get.find<ProductHistoryController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
          length: productHistoryController.tabs.length,
          initialIndex: productHistoryController.tabIndex.value,
          child: Scaffold(
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
                        title: "${product.name!}",
                        color: Colors.black,
                        size: 16.0),
                    minorTitle(title: "History", color: Colors.grey),
                  ],
                ),
                bottom: TabBar(
                  indicatorColor: AppColors.mainColor,
                  indicatorWeight: 3,
                  labelColor: AppColors.mainColor,
                  controller: productHistoryController.tabController,
                  unselectedLabelColor: Colors.black,
                  onTap: (index) {
                    productHistoryController.tabIndex.value = index;
                    if (index == 0) {
                      salesController.getSalesBySaleId(productId: product.id);
                    }
                    if (index == 1) {
                      purchaseController.getPurchaseOrderItems(
                          productId: product.id);
                    }
                    if (index == 2) {
                      Get.find<ProductHistoryController>().getProductHistory(
                          stockId: "", type: "transfer", productId: product.id);
                    }
                    if (index == 3) {
                      Get.find<ProductController>().getBadStock(
                          shopId: shopController.currentShop.value!.id,
                          attendant: "",
                          product: product.id);
                    }
                  },
                  tabs: productHistoryController.tabs,
                ),
              ),
              body: Column(children: [
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                        controller: productHistoryController.tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          SalesPages(
                            productId: product.id,
                          ),
                          PurchasesPages(),
                          HistoryPages(),
                          BadStockPage(),
                        ]),
                  ),
                )
              ])),
        ));
  }
}

class HistoryPages extends StatelessWidget {
  HistoryPages({Key? key}) : super(key: key);
  ProductHistoryController productHistoryController =
      Get.find<ProductHistoryController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return productHistoryController.gettingHistoryLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productHistoryController.productTransferHistories.length == 0
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
                      itemCount: productHistoryController
                          .productTransferHistories.length,
                      itemBuilder: (context, index) {
                        ProductTransferHistories productModel =
                            productHistoryController.productTransferHistories
                                .elementAt(index);
                        return productHistoryContainer(productModel);
                      });
    });
  }
}

class PurchasesPages extends StatelessWidget {
  PurchaseController purchaseController = Get.find<PurchaseController>();

  PurchasesPages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return purchaseController.getPurchaseOrderItemLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : purchaseController.invoicesItems.isEmpty
              ? const Center(
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
                              margin: const EdgeInsets.only(
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
                                    purchaseController.purchasedItems.length,
                                    (index) {
                                  ProductHistoryModel productBody =
                                      ProductHistoryModel();
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
                      itemCount: purchaseController.invoicesItems.length,
                      itemBuilder: (context, index) {
                        InvoiceItem productBody =
                            purchaseController.invoicesItems.elementAt(index);

                        return productPurchaseHistoryContainer(productBody);
                      });
    });
  }
}

class BadStockPage extends StatelessWidget {
  ProductController productController = Get.find<ProductController>();

  BadStockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return productController.saveBadstockLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productController.badstocks.length == 0
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
                                    productController.badstocks.length,
                                    (index) {
                                  ProductHistoryModel productBody =
                                      ProductHistoryModel();
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
                      itemCount: productController.badstocks.length,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        BadStock badStock =
                            productController.badstocks.elementAt(index);

                        return productHistoryContainer(badStock);
                      });
    });
  }
}

class SalesPages extends StatelessWidget {
  final productId;
  SalesController salesController = Get.find<SalesController>();

  SalesPages({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.salesOrderItemLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : salesController.salesHistory.length == 0
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
                                  salesController.salesHistory.length, (index) {
                                InvoiceItem productBody = salesController
                                    .salesHistory
                                    .elementAt(index);
                                final y = productBody.product!.name;
                                final x = productBody.itemCount;
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
                      itemCount: salesController.salesHistory.length,
                      itemBuilder: (context, index) {
                        InvoiceItem saleOrderItemModel =
                            salesController.salesHistory.elementAt(index);
                        return productHistoryContainer(saleOrderItemModel);
                      });
    });
  }

  Widget productHistoryContainer(InvoiceItem saleOrderItemModel) {
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
                        "${saleOrderItemModel.product!.name}".capitalize!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      if (saleOrderItemModel.itemCount == 0)
                        Text(
                          "item returned",
                          style: TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      if (saleOrderItemModel.itemCount! > 0)
                        Text('Qty ${saleOrderItemModel.itemCount}'),
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(saleOrderItemModel.createdAt!)} '),
                    ],
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                      'BP/= ${shopController.currentShop.value?.currency}.${saleOrderItemModel.product!.buyingPrice}'),
                  Text(
                      'SP/=  ${shopController.currentShop.value?.currency}.${saleOrderItemModel.total}'),
                  Text(
                    "Cashier ${saleOrderItemModel.attendantid!.fullnames}",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
