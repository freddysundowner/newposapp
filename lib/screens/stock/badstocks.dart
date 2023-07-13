import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/products_screen.dart';
import 'package:pointify/screens/sales/all_sales.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../controllers/product_controller.dart';
import '../../utils/themer.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/no_items_found.dart';
import '../finance/profit_page.dart';

class BadStockPage extends StatelessWidget {
  final page;

  BadStockPage({Key? key, required this.page}) : super(key: key) {}

  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();
  UserController attendantController = Get.find<UserController>();
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
                  if (!isSmallScreen(context)) {
                    if (page == "services") {
                      Get.find<HomeController>().selectedWidget.value =
                          AllSalesPage(page: "badstock");
                    } else if (page == "profitspage") {
                      Get.find<HomeController>().selectedWidget.value =
                          ProfitPage();
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
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: majorTitle(
                  title: "Bad Stock", color: Colors.black, size: 18.0),
            ),
            actions: [
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    productController.showBadStockWidget.value = true;
                    productController.getProductsBySort(type: "all");
                    isSmallScreen(context)
                        ? Get.to(() => CreateBadStock(page: page))
                        : Get.find<HomeController>().selectedWidget.value =
                            CreateBadStock(page: page);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      "Add New",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    final picked = await showDateRangePicker(
                        context: Get.context!,
                        lastDate: DateTime(2079),
                        firstDate: DateTime(2019),
                        builder: (context, child) {
                          return Column(
                            children: [
                              ConstrainedBox(
                                constraints:
                                    BoxConstraints(maxWidth: double.infinity),
                                child: Container(
                                    margin: EdgeInsets.only(
                                      left: isSmallScreen(context)
                                          ? 0
                                          : MediaQuery.of(context).size.width *
                                              0.2,
                                    ),
                                    child: child),
                              )
                            ],
                          );
                        });
                    Get.find<ProductController>().getBadStock(
                        shopId: shopController.currentShop.value!.id,
                        attendant: '',
                        product: null,
                        fromDate: DateTime.parse(
                            DateFormat("yyy-MM-dd").format(picked!.start)),
                        toDate: DateTime.parse(DateFormat("yyy-MM-dd")
                            .format(picked.end.add(const Duration(days: 1)))));
                  },
                  icon: Icon(
                    Icons.date_range,
                    color: AppColors.mainColor,
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
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
                          : isSmallScreen(context)
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: productController.badstocks.length,
                                  itemBuilder: (context, index) {
                                    BadStock badstock = productController
                                        .badstocks
                                        .elementAt(index);
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.symmetric(
                                              horizontal: 10)
                                          .copyWith(bottom: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                offset: Offset(1, 1),
                                                blurRadius: 1,
                                                color: Colors.grey)
                                          ]),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        badstock.product!.name!
                                                            .capitalize!,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                    Text(DateFormat(
                                                            "yyyy-MM-dd H:mm a")
                                                        .format(badstock
                                                            .createdAt!))
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${badstock.description}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Quantity: ${badstock.quantity!.toString()} @${htmlPrice(badstock.product!.buyingPrice)} = ${htmlPrice(badstock.product!.buyingPrice! * badstock.quantity!)}",
                                                      style: const TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                        "By: ${badstock.attendantId!.username}",
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
                                  })
                              : Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
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
                                      columns: const [
                                        DataColumn(
                                            label: Text('Name',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Reason',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Quantity',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Attendant',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Date',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          productController.badstocks.length,
                                          (index) {
                                        BadStock badstock = productController
                                            .badstocks
                                            .elementAt(index);
                                        final y = badstock.product?.name;
                                        final r = badstock.description;
                                        final h = badstock.quantity;
                                        final x =
                                            badstock.attendantId?.username;
                                        final z = badstock.createdAt;

                                        return DataRow(cells: [
                                          DataCell(Text(y!)),
                                          DataCell(Text(r!)),
                                          DataCell(Text(h.toString())),
                                          DataCell(Text(x!)),
                                          DataCell(Text(
                                              DateFormat("yyyy-dd-MMM ")
                                                  .format(z!))),
                                        ]);
                                      }),
                                    ),
                                  ),
                                );
                })
              ],
            ),
          )),
    );
  }
}

class CreateBadStock extends StatelessWidget {
  final page;
  ProductController productController = Get.find<ProductController>();

  CreateBadStock({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Add Bad Stock",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            if (isSmallScreen(Get.context)) {
              Get.back();
            } else {
              Get.find<HomeController>().selectedWidget.value =
                  BadStockPage(page: page);
            }
          },
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
            size: 23,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: isSmallScreen(context) ? 10 : 20, vertical: 10),
        width: double.infinity,
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
                      productController.getProductsBySort(
                        type: "all",
                      );
                      if (isSmallScreen(Get.context)) {
                        Get.to(() => ProductsScreen(
                              type: "badstock",
                              function: (Product product) {
                                productController.selectedBadStock.value =
                                    product;
                                Navigator.pop(context);
                              },
                            ));
                      } else {
                        Get.find<HomeController>().selectedWidget.value =
                            ProductsScreen(
                          type: "badstock",
                          function: (Product product) {
                            productController.selectedBadStock.value = product;

                            Get.find<HomeController>().selectedWidget.value =
                                CreateBadStock(
                              page: page,
                            );
                          },
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
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
                        const Icon(Icons.arrow_drop_down, color: Colors.grey)
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text("Qty", style: TextStyle(color: Colors.grey)),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: productController.qtyController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Quantity Spoiled",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2.0)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2.0)),
                  ),
                ),
                const SizedBox(
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
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.grey)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2.0)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2.0)),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Obx(() {
                    return productController.saveBadstockLoad.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Save'.toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              if (productController
                                      .qtyController.text.isEmpty ||
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
                                isSmallScreen(context)
                                    ? Get.back()
                                    : Get.find<HomeController>()
                                        .selectedWidget
                                        .value = BadStockPage(page: page);
                              }
                            },
                          );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
