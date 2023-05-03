import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/badstock.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/sales/all_sales_page.dart';
import 'package:flutterpos/screens/stock/stock_page.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
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
                        productController.getProductsBySort(
                            shopId: shopController.currentShop.value!.id!,
                            type: "all");
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
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
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )
                : productController.badstocks.isEmpty
                    ? noItemsFound(context, true)
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productController.badstocks.length,
                        itemBuilder: (context, index) {
                          BadStock badstock =
                              productController.badstocks.elementAt(index);
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 10)
                                .copyWith(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(1, 1),
                                      blurRadius: 1,
                                      color: Colors.grey)
                                ]),
                            child: Row(
                              children: [
                                // CircleAvatar(
                                //   backgroundColor: Colors.deepPurple,
                                //   child: ClipOval(
                                //     child: Icon(
                                //       Icons.water_damage,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${badstock.product!.name!}"
                                            .capitalize!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${badstock.description}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      SizedBox(
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
                                              style: TextStyle(
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
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.0), //(x,y)
            blurRadius: 1.0,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width * 0.4
          : double.infinity,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category", style: TextStyle(color: Colors.grey)),
              InkWell(
                onTap: () {
                  if (productController.products.length == 0 &&
                      !productController.getProductLoad.value) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("Add product to continue."),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Get.back();
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: List.generate(
                                productController.products.length,
                                (index) => SimpleDialogOption(
                                      onPressed: () {
                                        if (productController.products
                                                .elementAt(index)
                                                .quantity! >
                                            1) {
                                          productController
                                                  .selectedBadStock.value =
                                              productController.products
                                                  .elementAt(index);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                          "${productController.products.elementAt(index).name}"),
                                    )),
                          );
                        });
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
              Text("Qty", style: TextStyle(color: Colors.grey)),
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
              Text("Describe", style: TextStyle(color: Colors.grey)),
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
                              style: TextStyle(
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
                                  shop:
                                      "${shopController.currentShop.value?.id!}",
                                  attendant: authController.usertype == "admin"
                                      ? authController.currentUser.value!.id
                                      : attendantController.attendant.value!.id,
                                  page: page,
                                  context: context);
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
