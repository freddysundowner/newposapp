import 'package:flutter/material.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/product_history.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/services/product.dart';
import 'package:pointify/utils/constants.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import 'count_history.dart';

class StockCount extends StatelessWidget {
  StockCount({Key? key}) : super(key: key) {
    productController.searchProductCountController.text = "";
    productController.getProductsCount(type: "all");
  }

  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    print(
        "productController.productsCount.length ${productController.productsCount.length}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0.3,
        titleSpacing: 0.0,
        leading:
            Get.find<UserController>().user.value?.usertype == "attendant" &&
                    MediaQuery.of(context).size.width > 600
                ? Container()
                : IconButton(
                    onPressed: () {
                      if (MediaQuery.of(context).size.width > 600) {
                        Get.find<HomeController>().selectedWidget.value =
                            StockPage();
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
                    title: "Stock Count", color: Colors.black, size: 16.0),
                minorTitle(
                    title: "${shopController.currentShop.value?.name}",
                    color: Colors.grey)
              ],
            ),
            MediaQuery.of(context).size.width > 600 &&
                    Get.find<UserController>().user.value?.usertype == "admin"
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        Get.find<HomeController>().selectedWidget.value =
                            CountHistory();
                      },
                      child: majorTitle(
                          title: "Count History",
                          color: Colors.black,
                          size: 16.0),
                    ),
                  )
                : Container()
          ],
        ),
      ),
      body: ResponsiveWidget(
        largeScreen: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Expanded(child: searchTextField()),
                      SizedBox(width: 50),
                      sortWidget(context)
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Obx(() {
                  return productController.getProductCountLoad.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : productController.products.length == 0
                          ? noItemsFound(context, true)
                          : Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.grey),
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(right: 10, bottom: 30),
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
                                        label: Text('Count',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Date',
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
                                    final x = productBody.quantity.toString();
                                    final w = productBody.createdAt;

                                    return DataRow(cells: [
                                      DataCell(Container(
                                          width: 75, child: Text(y!))),
                                      DataCell(Container(
                                        child: Row(children: [
                                          IconButton(
                                              onPressed: () {
                                                productController
                                                    .decreamentInitial(index);
                                              },
                                              icon: Icon(Icons.remove,
                                                  color: Colors.black,
                                                  size: 16)),
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 8,
                                                  left: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.1),
                                                color: Colors.grey,
                                              ),
                                              child: majorTitle(
                                                  title:
                                                      "${productBody.quantity}",
                                                  color: Colors.black,
                                                  size: 12.0)),
                                          IconButton(
                                              onPressed: () {
                                                productController
                                                    .products[index]
                                                    .quantity = 34;
                                              },
                                              icon: Icon(Icons.add,
                                                  color: Colors.black,
                                                  size: 16)),
                                        ]),
                                      )),
                                      DataCell(Container(
                                          child: Text(
                                              DateFormat("yyyy-dd-MMM hh:mm a")
                                                  .format(w!)))),
                                      DataCell(Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      "Confirm Product Count",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    // content: Text("Do you want to delete this item?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          "Cancel"
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .mainColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          // Get.find<
                                                          //         ProductController>()
                                                          //     .updateQuantity(
                                                          //         product:
                                                          //             productBody);
                                                          // Get.back();
                                                        },
                                                        child: Text(
                                                          "Okay".toUpperCase(),
                                                          style: TextStyle(
                                                            color: AppColors
                                                                .mainColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 10, right: 3),
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: Colors.blue[300],
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.check),
                                                  Text('OK')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                    ]);
                                  }),
                                ),
                              ),
                            );
                })
              ],
            ),
          ),
        ),
        smallScreen: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: searchTextField(),
                  ),
                  if (userController.user.value?.usertype == "admin")
                    IconButton(
                        onPressed: () async {
                          productController.scanQR(
                              shopId: "${shopController.currentShop.value!.id}",
                              type: "count",
                              context: context);
                        },
                        icon: Icon(Icons.qr_code))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Items Available'),
                  Obx(() {
                    return Text("${productController.productsCount.length}");
                  })
                ],
              ),
            ),
            if (Get.find<RealmController>().currentUser!.value != null &&
                userController.user.value?.usertype == "admin")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Count History'),
                    InkWell(
                      onTap: () {
                        Get.to(() => CountHistory());
                      },
                      child:
                          minorTitle(title: "View", color: AppColors.mainColor),
                    )
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sort By"),
                  sortWidget(context),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: productController.productsCount.length,
                  itemBuilder: (context, index) {
                    ProductCountModel productCount =
                        productController.productsCount.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(productCount.product!.name!),
                                      Text('System Count'),
                                      Text('${productCount.product!.quantity}')
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Physical Count'),
                                      Row(children: [
                                        IconButton(
                                            onPressed: () {
                                              productController
                                                  .decreamentInitial(index);
                                            },
                                            icon: const Icon(Icons.remove)),
                                        Text('${productCount.quantity}'),
                                        IconButton(
                                            onPressed: () {
                                              productController
                                                  .increamentInitial(index);
                                            },
                                            icon: Icon(Icons.add))
                                      ])
                                    ],
                                  ),
                                  MediaQuery.of(context).size.width < 600
                                      ? _incrementQuantityWidget(
                                          productCountModel: productCount)
                                      : Container(),
                                ],
                              ),
                              MediaQuery.of(context).size.width > 600
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          width: 80,
                                          child: _incrementQuantityWidget(
                                              productCountModel: productCount)),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            })
          ]),
        ),
      ),
    );
  }

  Widget _incrementQuantityWidget(
      {required ProductCountModel productCountModel}) {
    return InkWell(
      onTap: () {
        showDialog(
            context: Get.context!,
            builder: (_) {
              return AlertDialog(
                title: const Text(
                  "Confirm Product Count",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Products().createProductCount(
                          productCountModel: productCountModel);
                      Get.back();
                      productController.productsCount.refresh();
                    },
                    child: Text(
                      "Okay".toUpperCase(),
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[300], borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [Icon(Icons.check), Text('OK')],
          ),
        ),
      ),
    );
  }

  Widget sortWidget(context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              children: List.generate(
                  Constants().sortOrderCaunt.length,
                  (index) => SimpleDialogOption(
                        onPressed: () {
                          productController.selectedSortOrderCount.value =
                              Constants().sortOrderCaunt.elementAt(index);
                          productController.selectedSortOrderCountSearch.value =
                              Constants().sortOrderCauntList.elementAt(index);
                          productController.getProductsCount(
                              type: Constants()
                                  .sortOrderCauntList
                                  .elementAt(index));
                          Navigator.pop(context);
                        },
                        child: Text(
                          Constants().sortOrderCaunt.elementAt(index),
                        ),
                      )),
            );
          },
        );
      },
      child: Row(
        children: [
          Obx(() {
            return Text(productController.selectedSortOrderCount.value,
                style: TextStyle(color: AppColors.mainColor));
          }),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.mainColor,
          )
        ],
      ),
    );
  }

  Widget searchTextField() {
    return TextFormField(
      controller: productController.searchProductCountController,
      onChanged: (value) {
        if (value == "") {
          productController.getProductsCount(
              type: "all",
              text: productController.searchProductCountController.text);
        } else {
          productController.getProductsCount(
              type: "search",
              text: productController.searchProductCountController.text);
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        suffixIcon: IconButton(
          onPressed: () {
            productController.getProductsCount(
                type: "search",
                text: productController.searchProductCountController.text);
          },
          icon: Icon(Icons.search),
        ),
        hintText: "Quick Search Item",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
      ),
    );
  }
}
