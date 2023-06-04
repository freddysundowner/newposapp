import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/product/products_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../../Real/Models/schema.dart';
import '../../controllers/stock_transfer_controller.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import 'components/product_history_card.dart';

class ProductHistory extends StatelessWidget {
  final Product product;

  ProductHistory({Key? key, required this.product}) : super(key: key) {
    salesController.getSalesByProductId(product: product);
  }

  StockTransferController stockTransferController =
      Get.find<StockTransferController>();
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();

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
        body: DefaultTabController(
            initialIndex: 0,
            length: 4,
            child: Builder(builder: (context) {
              return Column(children: [
                TabBar(
                  controller: DefaultTabController.of(context),
                  onTap: (index) {
                    if (index == 0) {
                      salesController.getSalesByProductId(product: product);
                    }
                    if (index == 1) {}
                    if (index == 2) {
                      stockTransferController
                          .getProductTransferHistory(product);
                    }
                    if (index == 3) {
                      Get.find<ProductController>().getBadStock(
                          shopId: shopController.currentShop.value!.id,
                          attendant: "",
                          product: product);
                    }
                  },
                  tabs: [
                    Tab(
                      child: Text(
                        "Sales",
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ),
                    Tab(
                        child: Text(
                      "Purchase",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )),
                    Tab(
                        child: Text(
                      "Transfer",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )),
                    Tab(
                        child: Text(
                      "Bad Stock",
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    )),
                  ],
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                        controller: DefaultTabController.of(context),
                        children: [
                          SalesPages(
                            productId: product.id,
                          ),
                          PurchasesPages(
                            product: product,
                          ),
                          HistoryPages(),
                          BadStockPage(),
                        ]),
                  ),
                )
              ]);
            })));
  }
}

class HistoryPages extends StatelessWidget {
  HistoryPages({Key? key}) : super(key: key);
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return stockTransferController.productTransferHistory.isEmpty
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
                          margin:
                              EdgeInsets.only(right: 15, left: 15, bottom: 20),
                          // child: DataTable(
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //     width: 1,
                          //     color: Colors.black,
                          //   )),
                          //   columnSpacing: 30.0,
                          //   columns: [
                          //     DataColumn(
                          //         label: Text('Product',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Quantity',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Buying Price',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Selling Price',
                          //             textAlign: TextAlign.center)),
                          //     DataColumn(
                          //         label: Text('Date',
                          //             textAlign: TextAlign.center)),
                          //   ],
                          //   // rows: List.generate(
                          //   //     productHistoryController.product.length,
                          //   //     (index) {
                          //   //   ProductHistoryModel productBody =
                          //   //       productHistoryController.product
                          //   //           .elementAt(index);
                          //   //   final y = productBody.product!.name;
                          //   //   final x = productBody.quantity;
                          //   //   final w = productBody.product!.buyingPrice;
                          //   //   final z = productBody.product!.sellingPrice![0];
                          //   //   final a = productBody.createdAt;
                          //   //
                          //   //   return DataRow(cells: [
                          //   //     DataCell(Container(width: 75, child: Text(y!))),
                          //   //     DataCell(Container(
                          //   //         width: 75, child: Text(x.toString()))),
                          //   //     DataCell(Container(
                          //   //         width: 75, child: Text(w.toString()))),
                          //   //     DataCell(Container(
                          //   //         width: 75, child: Text(z.toString()))),
                          //   //     DataCell(Container(
                          //   //         width: 75,
                          //   //         child: Text(
                          //   //             DateFormat("dd-MM-yyyy").format(a!)))),
                          //   //   ]);
                          //   // }),
                          // ),
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      stockTransferController.productTransferHistory.length,
                  itemBuilder: (context, index) {
                    ProductHistoryModel productModel = stockTransferController
                        .productTransferHistory
                        .elementAt(index);
                    return productHistoryContainer(productModel);
                  });
    });
  }
}

class PurchasesPages extends StatelessWidget {
  ProductController productController = Get.find<ProductController>();
  Product? product;
  PurchasesPages({Key? key, this.product}) : super(key: key) {
    productController.getProductPurchaseHistory(product!);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return productController.productInvoices.isEmpty
          ? const Center(
              child: Text("There are no iems to display"),
            )
          : MediaQuery.of(context).size.width > 600
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      // Theme(
                      //   data: Theme.of(context)
                      //       .copyWith(dividerColor: Colors.grey),
                      //   child: Container(
                      //     width: double.infinity,
                      //     margin: const EdgeInsets.only(
                      //         right: 15, left: 15, bottom: 20),
                      //     child: DataTable(
                      //       decoration: BoxDecoration(
                      //           border: Border.all(
                      //         width: 1,
                      //         color: Colors.black,
                      //       )),
                      //       columnSpacing: 30.0,
                      //       columns: [
                      //         DataColumn(
                      //             label: Text('Product',
                      //                 textAlign: TextAlign.center)),
                      //         DataColumn(
                      //             label: Text('Quantity',
                      //                 textAlign: TextAlign.center)),
                      //         DataColumn(
                      //             label: Text('Buying Price',
                      //                 textAlign: TextAlign.center)),
                      //         DataColumn(
                      //             label: Text('Selling Price',
                      //                 textAlign: TextAlign.center)),
                      //         DataColumn(
                      //             label: Text('Date',
                      //                 textAlign: TextAlign.center)),
                      //       ],
                      //       rows: List.generate(
                      //           purchaseController.purchasedItems.length,
                      //           (index) {
                      //         ProductHistoryModel productBody =
                      //             ProductHistoryModel(ObjectId());
                      //         final y = productBody.product!.name;
                      //         final x = productBody.quantity;
                      //         final w = productBody.product!.buyingPrice;
                      //         final z = productBody.product!.sellingPrice[0];
                      //         final a = productBody.createdAt;
                      //
                      //         return DataRow(cells: [
                      //           DataCell(Container(width: 75, child: Text(y!))),
                      //           DataCell(Container(
                      //               width: 75, child: Text(x.toString()))),
                      //           DataCell(Container(
                      //               width: 75, child: Text(w.toString()))),
                      //           DataCell(Container(
                      //               width: 75, child: Text(z.toString()))),
                      //           DataCell(Container(
                      //               width: 75,
                      //               child: Text(
                      //                   DateFormat("dd-MM-yyyy").format(a!)))),
                      //         ]);
                      //       }),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 30)
                    ],
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: productController.productInvoices.length,
                  itemBuilder: (context, index) {
                    InvoiceItem productBody =
                        productController.productInvoices.elementAt(index);

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
          : productController.badstocks.isEmpty
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
                                      ProductHistoryModel(ObjectId());
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

                        return productBadStockHistory(badStock);
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
      return salesController.productSales.isEmpty
          ? Center(
              child: Text("There are no iems to display"),
            )
          : MediaQuery.of(context).size.width > 600
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.grey),
                      child: Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
                                label:
                                    Text('Date', textAlign: TextAlign.center)),
                          ],
                          rows: List.generate(
                              salesController.salesHistory.length, (index) {
                            InvoiceItem productBody =
                                salesController.salesHistory.elementAt(index);
                            final y = productBody.product!.name;
                            final x = productBody.itemCount;
                            final w = productBody.product!.buyingPrice;
                            final z = productBody.product!.sellingPrice![0];
                            final a = productBody.createdAt;

                            return DataRow(cells: [
                              DataCell(Container(width: 75, child: Text(y!))),
                              DataCell(Container(
                                  width: 75, child: Text(x.toString()))),
                              DataCell(Container(
                                  width: 75, child: Text(w.toString()))),
                              DataCell(Container(
                                  width: 75, child: Text(z.toString()))),
                              DataCell(Container(
                                  width: 75,
                                  child: Text(DateFormat("yyyy-dd-MM hh:mm a")
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
                  itemCount: salesController.productSales.length,
                  itemBuilder: (context, index) {
                    ReceiptItem receiptItem =
                        salesController.productSales.elementAt(index);
                    return productHistoryContainer(receiptItem);
                  });
    });
  }

  Widget productHistoryContainer(ReceiptItem receiptItem) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${receiptItem.product!.name}".capitalize!,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  if (receiptItem.quantity == 0)
                    Text(
                      "item returned",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  if (receiptItem.quantity! > 0)
                    Text('Qty ${receiptItem.quantity} @ ${receiptItem.price}'),
                  if (receiptItem.createdAt != null)
                    Text(
                        '${DateFormat("MMM dd,yyyy, hh:m a").format(receiptItem.createdAt!)} '),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
