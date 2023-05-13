import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/badstock.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/products_screen.dart';
import 'package:pointify/screens/sales/all_sales_page.dart';
import 'package:pointify/screens/stock/products_selection.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:pointify/widgets/alert.dart';

import '../../controllers/product_controller.dart';
import '../../models/product_history_model.dart';
import '../../models/product_model.dart';
import '../../utils/themer.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/no_items_found.dart';

class BadStockPage extends StatelessWidget {
  final page;

  BadStockPage({Key? key, required this.page}) : super(key: key) {
    productController.getBadStock(
        shopId: shopController.currentShop.value!.id,
        attendant: authController.usertype.value == "admin"
            ? ""
            : attendantController.attendant.value?.id!,
        product: "");
  }

  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();
  AttendantController attendantController = Get.find<AttendantController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        productController.showBadStockWidget.value = false;
        productController.selectedBadStock.value = null;
        productController.qtyController.clear();
        productController.itemNameController.clear();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.3,
          titleSpacing: 0.0,
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  if (page == "sales") {
                    Get.find<HomeController>().selectedWidget.value =
                        AllSalesPage(page: "badstock");
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        StockPage();
                  }
                } else {
                  Get.back();
                }
                productController.showBadStockWidget.value = false;
                productController.selectedBadStock.value = null;
                productController.qtyController.clear();
                productController.itemNameController.clear();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child:
                majorTitle(title: "Bad Stock", color: Colors.black, size: 18.0),
          ),
        ),
        body: ResponsiveWidget(
          smallScreen: _body(context),
          largeScreen: _body(context),
        ),
      ),
    );
  }

  Widget _body(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(() {
            return productController.showBadStockWidget.value
                ? badStockWidget(context: context)
                : Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        productController.showBadStockWidget.value = true;
                        productController.getProductsBySort(type: "all");
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Add New",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
          }),
          Obx(() {
            return productController.saveBadstockLoad.value
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : productController.badstocks.isEmpty
                    ? noItemsFound(context, true)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productController.badstocks.length,
                        itemBuilder: (context, index) {
                          BadStock badstock =
                              productController.badstocks.elementAt(index);
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 10)
                                .copyWith(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 1,
                                      color: Colors.grey)
                                ]),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        badstock.product!.name!.capitalize!,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${badstock.description}",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Quantity: ${badstock.quantity!.toString()}",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              "By: ${badstock.attendantId!.fullnames}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
          })
        ],
      ),
    );
  }

  Widget badStockWidget({required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width * 0.4
          : double.infinity,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select product",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (productController.products.isEmpty &&
                      !productController.getProductLoad.value) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text("Add product to continue."),
                            actions: [
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Get.back();
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    Get.to(() => ProductsScreen(
                          shopId: shopController.currentShop.value!.id,
                          type: "badstock",
                          function: (ProductModel product) {
                            productController.selectedBadStock.value = product;
                            Navigator.pop(context);
                          },
                        ));
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        return Text(
                            productController.selectedBadStock.value?.name ??
                                "Select product");
                      }),
                      Icon(Icons.arrow_drop_down, color: Colors.grey)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("Qty", style: TextStyle(color: Colors.grey)),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: productController.qtyController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Quantity Spoiled",
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Text("Reason", style: TextStyle(color: Colors.grey)),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: productController.itemNameController,
                decoration: InputDecoration(
                  hintText: "Give a reason",
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.red, width: 2.0)),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Obx(() {
                  return productController.saveBadstockLoad.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              'Save'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            if (productController.qtyController.text.isEmpty ||
                                productController
                                    .itemNameController.text.isEmpty ||
                                productController.selectedBadStock.value ==
                                    null) {
                              missingValueDialog(
                                  context, "Please fill all the fields");
                            } else if (int.parse(
                                    "${productController.selectedBadStock.value?.quantity!}") <
                                int.parse(
                                    productController.qtyController.text)) {
                              missingValueDialog(context,
                                  "Quantity Can't be greater than ${productController.selectedBadStock.value?.quantity}");
                            } else {
                              productController.saveBadStock(
                                  page: page, context: context);
                            }
                          },
                        );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
