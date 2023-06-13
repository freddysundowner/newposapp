import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/stock_transfer_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/stock_transfer.dart';
import 'package:pointify/screens/stock/stock_transfer_submit.dart';
import 'package:get/get.dart';

import '../../Real/Models/schema.dart';
import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/snackBars.dart';

class ProductSelections extends StatelessWidget {
  final Shop toShop;

  ProductSelections({Key? key, required this.toShop}) : super(key: key) {
    // productController.getProductsBySort(type: "all");
  }

  ProductController productController = Get.find<ProductController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();
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
    return WillPopScope(
      onWillPop: () async {
        stockTransferController.selectedProducts.value = [];
        stockTransferController.selectedProducts.refresh();
        productController.products.refresh();
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            titleSpacing: 0.0,
            backgroundColor: Colors.white,
            elevation: 0.3,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                stockTransferController.selectedProducts.value = [];
                stockTransferController.selectedProducts.refresh();
                productController.products.refresh();
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      StockTransfer();
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title: "Product Selection",
                        color: Colors.black,
                        size: 16.0),
                  ],
                ),

                // stockTransferController.selectedProducts.length == 0
                MediaQuery.of(context).size.width > 600
                    ? Obx(() {
                        return stockTransferController.selectedProducts.isEmpty
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.find<HomeController>()
                                        .selectedWidget
                                        .value = StockSubmit(
                                      toShop: toShop,
                                    );
                                  },
                                  child: majorTitle(
                                      title: "Proceed",
                                      color: Colors.black,
                                      size: 16.0),
                                ),
                              );
                      })
                    : Container()
              ],
            ),
          ),
          body: ResponsiveWidget(
              largeScreen: SingleChildScrollView(
                child: SingleChildScrollView(
                  child: Container(
                    child: Obx(() {
                      return productController.getProductLoad.value
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : productController.products.isEmpty
                              ? const Center(
                                  child: Text("no products to transfer"),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: Theme(
                                    data: Theme.of(context)
                                        .copyWith(dividerColor: Colors.grey),
                                    child: DataTable(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      )),
                                      columnSpacing: 30.0,
                                      columns: [
                                        DataColumn(
                                            label: Text('Name',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Category',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Quantity',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          productController.products.length,
                                          (index) {
                                        Product productBody = productController
                                            .products
                                            .elementAt(index);
                                        final y = productBody.name;
                                        final x = productBody.category!.name;
                                        final z = productBody.quantity;

                                        return DataRow(cells: [
                                          DataCell(Container(
                                              width: 75, child: Text(y!))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(x.toString()))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(z.toString()))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Checkbox(
                                                  value: stockTransferController
                                                              .selectedProducts
                                                              .indexWhere(
                                                                  (element) =>
                                                                      element
                                                                          .product!
                                                                          .id ==
                                                                      productBody
                                                                          .id) !=
                                                          -1
                                                      ? true
                                                      : false,
                                                  onChanged: (bool? value) {
                                                    if (productBody.quantity! >
                                                        0) {
                                                      stockTransferController
                                                          .addToList(
                                                              productBody);
                                                    } else {
                                                      showSnackBar(
                                                          message:
                                                              "You cannot transfer product that is out of stock",
                                                          color: Colors.red);
                                                    }
                                                  },
                                                ),
                                              ))),
                                        ]);
                                      }),
                                    ),
                                  ),
                                );
                    }),
                  ),
                ),
              ),
              smallScreen: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: searchWidget()),
                  Obx(() {
                    return productController.products.isEmpty
                        ? Center(
                            child: Text("no products to transfer"),
                          )
                        : ListView.builder(
                            itemCount: productController.products.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              Product productBody =
                                  productController.products.elementAt(index);
                              return InkWell(
                                onTap: () {
                                  if (productBody.quantity! > 0) {
                                    // productBody.cartquantity = 1;
                                    stockTransferController
                                        .addToList(productBody);
                                  } else {
                                    showSnackBar(
                                        message:
                                            "You cannot transfer product that is out of stock",
                                        color: Colors.red);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              majorTitle(
                                                  title: "${productBody.name}",
                                                  color: Colors.black,
                                                  size: 16.0),
                                              SizedBox(height: 10),
                                              minorTitle(
                                                  title:
                                                      "Category: ${productBody.category!.name}",
                                                  color: Colors.grey),
                                              SizedBox(height: 10),
                                              Text(
                                                  "Qty Available: ${productBody.quantity}",
                                                  style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 16))
                                            ],
                                          ),
                                          Checkbox(
                                              value: stockTransferController
                                                          .selectedProducts
                                                          .indexWhere(
                                                              (element) =>
                                                                  element
                                                                      .product!
                                                                      .id ==
                                                                  productBody
                                                                      .id) !=
                                                      -1
                                                  ? true
                                                  : false,
                                              onChanged: (value) {})
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                  }),
                ],
              )),
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
                          Get.to(() => StockSubmit(
                                toShop: toShop,
                              ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3, color: AppColors.mainColor),
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                              child: majorTitle(
                                  title: "Proceed",
                                  color: AppColors.mainColor,
                                  size: 18.0)),
                        ),
                      ),
                    );
            }),
          )),
    );
  }
}
