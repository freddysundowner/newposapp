import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/stock/stock_transfer_submit.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/snackBars.dart';

class ProductSelections extends StatelessWidget {
  final ShopModel shopModel;

  ProductSelections({Key? key, required this.shopModel}) : super(key: key) {
    productController.searchProduct(shopModel.id!, "selection");
  }

  ProductController productController = Get.find<ProductController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    productController.getProductsBySort(
        shopId: "${shopController.currentShop.value?.id}",
        type: productController.selectedSortOrderSearch.value);
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
                Get.back();
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
                        return stockTransferController
                                    .selectedProducts.length ==
                                0
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => StockSubmit(
                                          to: shopModel.id,
                                        ));
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
          body: ResponsiveWidget(largeScreen: Container(
            child: Obx(() {
              return productController.getProductLoad.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : productController.products.length == 0
                      ? Center(
                          child: Text("no products to transfer"),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width *
                                          1.4 /
                                          MediaQuery.of(context).size.height,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: productController.products.length,
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            ProductModel productBody =
                                productController.products.elementAt(index);
                            return InkWell(
                              onTap: () {
                                if (productBody.quantity! > 0) {
                                  stockTransferController
                                      .addToList(productBody);
                                } else {
                                  showSnackBar(
                                      message:
                                          "You cannot transfer product that is outof stock",
                                      color: Colors.red,
                                      context: context);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 4,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 16))
                                          ],
                                        ),
                                        Checkbox(
                                            value: stockTransferController
                                                        .selectedProducts
                                                        .indexWhere((element) =>
                                                            element.id ==
                                                            productBody.id) !=
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
          ), smallScreen: Obx(() {
            return productController.getProductLoad.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : productController.products.length == 0
                    ? Center(
                        child: Text("no products to transfer"),
                      )
                    : ListView.builder(
                        itemCount: productController.products.length,
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          ProductModel productBody =
                              productController.products.elementAt(index);
                          return InkWell(
                            onTap: () {
                              if (productBody.quantity! > 0) {
                                stockTransferController.addToList(productBody);
                              } else {
                                showSnackBar(
                                    message:
                                        "You cannot transfer product that is outof stock",
                                    color: Colors.red,
                                    context: context);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 4,
                                child: Container(
                                  padding: EdgeInsets.all(10),
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
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16))
                                        ],
                                      ),
                                      Checkbox(
                                          value: stockTransferController
                                                      .selectedProducts
                                                      .indexWhere((element) =>
                                                          element.id ==
                                                          productBody.id) !=
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
          })),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Obx(() {
              return stockTransferController.selectedProducts.length == 0 ||
                      MediaQuery.of(context).size.width > 600
                  ? Container(
                      height: 0,
                    )
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      height: kToolbarHeight * 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => StockSubmit(
                                to: shopModel.id,
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
