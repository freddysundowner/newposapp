import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/stock_transfer_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/products_selection.dart';
import 'package:pointify/utils/colors.dart';
import 'package:get/get.dart';

import '../../Real/Models/schema.dart';
import '../../widgets/bigtext.dart';

class StockSubmit extends StatelessWidget {
  final Shop toShop;

  StockSubmit({Key? key, required this.toShop}) : super(key: key);
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  Widget searchWidget() {
    return TextFormField(
      controller: productController.searchProductController,
      onChanged: (value) {
        if (value == "") {
          productController.getProductsBySort(
            type: "all",
          );
        } else {
          productController.getProductsBySort(
              type: "search",
              text: productController.searchProductController.text);
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        suffixIcon: IconButton(
          onPressed: () {
            productController.getProductsBySort(
                type: "search",
                text: productController.searchProductController.text);
          },
          icon: Icon(Icons.search),
        ),
        hintText: "Quick Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0.2,
        title: Text(
          "Transfer",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).size.width > 600) {
                Get.find<HomeController>().selectedWidget.value =
                    ProductSelections(toShop: toShop);
              } else {
                Get.back();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Obx(() {
          return stockTransferController.selectedProducts.isEmpty ||
                  MediaQuery.of(context).size.width > 600
              ? Container(
                  height: 0,
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  height: kToolbarHeight * 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      print(toShop.name);
                      stockTransferController.submitTranster(
                          toShop: toShop, context: context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: majorTitle(
                              title: "Complete",
                              color: AppColors.mainColor,
                              size: 18.0)),
                    ),
                  ),
                );
        }),
      ),
      body: ResponsiveWidget(
          largeScreen: Obx(() => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.grey),
                    child: DataTable(
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.black,
                      )),
                      columnSpacing: 30.0,
                      columns: [
                        DataColumn(
                            label: Text('Name', textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('System Count',
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label:
                                Text('Quantity', textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('', textAlign: TextAlign.center)),
                      ],
                      rows: List.generate(
                          stockTransferController.selectedProducts.length,
                          (index) {
                        Product productModel = stockTransferController
                            .selectedProducts
                            .elementAt(index)
                            .product!;
                        final y = productModel.name;
                        final x = productModel.quantity;
                        final z = productModel.cartquantity;

                        return DataRow(cells: [
                          DataCell(Container(width: 75, child: Text(y!))),
                          DataCell(
                              Container(width: 75, child: Text(x.toString()))),
                          DataCell(Container(
                              width: 75,
                              child: Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (productModel.cartquantity! > 1) {
                                          productModel.cartquantity =
                                              productModel.cartquantity! - 1;
                                          stockTransferController
                                              .selectedProducts
                                              .refresh();
                                        }
                                      },
                                      child: Icon(Icons.remove_circle_outline)),
                                  Spacer(),
                                  Text(
                                    "${productModel.cartquantity}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {
                                        if (productModel.cartquantity! <
                                            productModel.quantity!) {
                                          productModel.cartquantity =
                                              productModel.cartquantity! + 1;
                                          stockTransferController
                                              .selectedProducts
                                              .refresh();
                                        }
                                      },
                                      child: Icon(Icons.add_circle_outline)),
                                ],
                              ))),
                          DataCell(Container(
                              width: 75,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                    onTap: () {
                                      stockTransferController.selectedProducts
                                          .removeWhere((element) =>
                                              element.product!.id ==
                                              productModel.id);
                                      stockTransferController.selectedProducts
                                          .refresh();
                                      productController.products.refresh();
                                    },
                                    child: Icon(Icons.clear)),
                              ))),
                        ]);
                      }),
                    ),
                  ),
                ),
              )),
          smallScreen: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ProductTransfer productTransfer =
                    stockTransferController.selectedProducts.elementAt(index);
                return Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, //New
                          blurRadius: 2.0,
                          offset: Offset(1, 1))
                    ],
                  ),
                  padding: EdgeInsets.all(10),
                  margin:
                      EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productTransfer.product!.name}".capitalize!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "System Count".capitalize!,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${productTransfer.product!.quantity}",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Transfer Count".capitalize!,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          print("vv");
                                          if (productTransfer.quantity! > 1) {
                                            productTransfer.quantity =
                                                productTransfer.quantity! - 1;
                                            stockTransferController
                                                .selectedProducts
                                                .refresh();
                                          }
                                        },
                                        child: const Icon(
                                            Icons.remove_circle_outline)),
                                    Spacer(),
                                    Text(
                                      "${productTransfer.quantity ?? 1}",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                    ),
                                    Spacer(),
                                    InkWell(
                                        onTap: () {
                                          if (productTransfer.quantity! <
                                              productTransfer
                                                  .product!.quantity!) {
                                            productTransfer.quantity =
                                                productTransfer.quantity! + 1;
                                            stockTransferController
                                                .selectedProducts
                                                .refresh();
                                          }
                                        },
                                        child: Icon(Icons.add_circle_outline)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              flex: 2,
                              child: InkWell(
                                onTap: () {
                                  stockTransferController.selectedProducts
                                      .removeWhere((element) =>
                                          element.product!.id ==
                                          productTransfer.product!.id);
                                  stockTransferController.selectedProducts
                                      .refresh();
                                  productController.products.refresh();
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: AppColors.mainColor,
                                ),
                              ))
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: stockTransferController.selectedProducts.length,
            ),
          )),
    );
  }
}
