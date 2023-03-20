import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/create_customers.dart';
import 'package:flutterpos/screens/stock/stock_page.dart';
import 'package:flutterpos/screens/stock/view_purchases.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:flutterpos/widgets/search_widget.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/purchase_controller.dart';
import '../../controllers/supplierController.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/purchases_card.dart';
import '../../widgets/smalltext.dart';
import '../product/product_selection.dart';

class CreatePurchase extends StatelessWidget {
  CreatePurchase({Key? key}) : super(key: key) {
    supplierController.getSuppliersInShop(
        shopController.currentShop.value?.id, "all");
  }

  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();
  AuthController authController = Get.find<AuthController>();
  ProductController productController = Get.find<ProductController>();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        purchaseController.selectedList.clear();
        return true;
      },
      child: ResponsiveWidget(
        largeScreen: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            centerTitle: false,
            leading: IconButton(
                onPressed: () {
                  if (MediaQuery.of(context).size.width > 600) {
                    if (authController.usertype.value == "attendant") {
                      Get.find<HomeController>().selectedWidget.value =
                          ViewPurchases();
                    } else {
                      Get.find<HomeController>().selectedWidget.value =
                          StockPage();
                    }
                  } else {
                    Get.back();
                  }
                  purchaseController.selectedList.clear();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: majorTitle(
                  title: "Add Purchase", color: Colors.black, size: 20.0),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                Container(
                  child: searchWidget(
                      autoCompletKey: _autocompleteKey,
                      focusNode: _focusNode,
                      shopId: shopController.currentShop.value?.id!,
                      page: "purchase"),
                  padding: EdgeInsets.only(left: 30, right: 80),
                ),
                Obx(() {
                  return purchaseController.selectedList.length == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                  "Totals:${purchaseController.calculateSalesAmount()}"),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  saveFunction(context);
                                },
                                child: majorTitle(
                                    title: "Create Purchase",
                                    color: AppColors.mainColor,
                                    size: 14.0),
                              )
                            ],
                          ),
                        );
                }),
                SizedBox(height: 20),
                Obx(() {
                  return productController.getProductLoad.value
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: MediaQuery.of(context).size.height * 0.4),
                            Center(child: CircularProgressIndicator()),
                          ],
                        )
                      : purchaseController.selectedList.length == 0
                          ? noItemsFound(context, true)
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.grey),
                                child: DataTable(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  )),
                                  columnSpacing: 50.0,
                                  columns: [
                                    DataColumn(
                                        label: Text('Product',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Qty',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Price',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Purchase Total',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('',
                                            textAlign: TextAlign.center)),
                                  ],
                                  rows: List.generate(
                                      purchaseController.selectedList.length,
                                      (index) {
                                    ProductModel productModel = purchaseController
                                        .selectedList
                                        .elementAt(index);
                                    final y = productModel.name!;
                                    final x =
                                        productModel.cartquantity.toString();
                                    final z = productModel.buyingPrice;
                                    final w =
                                        int.parse(productModel.sellingPrice![0]) *
                                            productModel.cartquantity!;

                                    return DataRow(cells: [
                                      DataCell(
                                          Container(width: 75, child: Text(y))),
                                      DataCell(Container(
                                        child: Row(children: [
                                          IconButton(
                                              onPressed: () {
                                                purchaseController
                                                    .decrementItem(index);
                                              },
                                              icon: Icon(Icons.remove,
                                                  color: Colors.black, size: 16)),
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
                                                      "${productModel.cartquantity}",
                                                  color: Colors.black,
                                                  size: 12.0)),
                                          IconButton(
                                              onPressed: () {
                                                purchaseController
                                                    .incrementItem(index);
                                              },
                                              icon: Icon(Icons.add,
                                                  color: Colors.black, size: 16)),
                                        ]),
                                      )),
                                      DataCell(
                                          Container(child: Text(z.toString()))),
                                      DataCell(
                                          Container(child: Text(w.toString()))),
                                      DataCell(Container(
                                          child: InkWell(
                                              onTap: () {
                                                purchaseController
                                                    .removeFromList(index);
                                              },
                                              child: Icon(Icons.clear))))
                                    ]);
                                  }),
                                ),
                              ),
                            );
                }),
              ],
            ),
          ),
        ),
        smallScreen: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            titleSpacing: 0.0,
            leading: IconButton(
                onPressed: () {
                  purchaseController.selectedList.clear();
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title: majorTitle(
                title: "Add Purchase", color: Colors.black, size: 20.0),
          ),
          body: Stack(
            children: [
              Obx(() {
                return purchaseController.selectedList.length == 0
                    ? Center(
                        child: minorTitle(
                            title: "No Items selected to stock in",
                            color: Colors.black),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: kToolbarHeight * 1.2,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    purchaseController.selectedList.length,
                                itemBuilder: (context, index) {
                                  ProductModel productModel = purchaseController
                                      .selectedList
                                      .elementAt(index);
                                  return purchasesCard(
                                      context: context,
                                      productModel: productModel,
                                      index: index);
                                }),
                          ],
                        ),
                      );
              }),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    elevation: 1,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => ProductSelection(
                                          shopId: shopController
                                              .currentShop.value?.id,
                                          type: "purchase",
                                        ));
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(15, 10, 15, 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Select products to StockIn"),
                                        Icon(Icons.arrow_drop_down,
                                            color: Colors.grey)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    purchaseController.scanQR(
                                        shopId: shopController
                                            .currentShop.value?.id,
                                        context: context);
                                  },
                                  icon: Icon(Icons.qr_code))
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          bottomNavigationBar: Obx(() {
            return BottomAppBar(
              color: Colors.white,
              child: purchaseController.selectedList.length == 0
                  ? Container(height: 0)
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      height: kToolbarHeight * 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: saveButton(context),
                    ),
            );
          }),
        ),
      ),
    );
  }

  Widget saveButton(context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        saveFunction(context);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: majorTitle(
                title: "Create Purchase",
                color: AppColors.mainColor,
                size: 18.0)),
      ),
    );
  }

  saveFunction(context) {
    if (purchaseController.selectedList.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          new SnackBar(content: Text("Please select products to sell")));
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return Container(
              width: double.infinity,
              child: AlertDialog(
                title: Center(child: Text("Confirm Stock In")),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  majorTitle(
                                      title: "Items",
                                      color: Colors.black,
                                      size: 16.0),
                                  SizedBox(height: 10),
                                  minorTitle(
                                      title:
                                          "${purchaseController.selectedList.length}",
                                      color: Colors.grey)
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  majorTitle(
                                      title: "Total",
                                      color: Colors.black,
                                      size: 16.0),
                                  SizedBox(height: 10),
                                  minorTitle(
                                      title:
                                          "${purchaseController.grandTotal.value}",
                                      color: Colors.grey)
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    minorTitle(
                                        title: "Amount ", color: Colors.black),
                                    TextFormField(
                                      controller: purchaseController
                                          .textEditingControllerAmount,
                                      onChanged: (value) {
                                        if (int.parse(value) >
                                            purchaseController
                                                .grandTotal.value) {
                                          purchaseController
                                                  .textEditingControllerAmount
                                                  .text =
                                              purchaseController
                                                  .grandTotal.value
                                                  .toString();
                                          purchaseController.balance.value = 0;
                                        } else if (purchaseController
                                                .textEditingControllerAmount
                                                .text ==
                                            "") {
                                          purchaseController.balance.value =
                                              purchaseController
                                                  .grandTotal.value;
                                        } else {
                                          purchaseController.balance.value =
                                              purchaseController
                                                      .grandTotal.value -
                                                  int.parse(value);
                                        }
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    majorTitle(
                                        title: "Balance",
                                        color: Colors.black,
                                        size: 13.0),
                                    Obx(() {
                                      return minorTitle(
                                          title:
                                              purchaseController.balance.value,
                                          color: Colors.grey);
                                    })
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          majorTitle(
                              title: "Select Supplier",
                              color: Colors.black,
                              size: 14.0),
                          SizedBox(height: 10),
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                if (supplierController.suppliers.length == 0) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              "This Shop Doesn't have suppliers"),
                                          content: Text(
                                              "Would you like to add Supplier?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Get.back();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Get.back();
                                                Get.to(() => CreateCustomer(
                                                    page: "createPurchase",
                                                    type: "suppliers"));
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
                                              supplierController
                                                  .suppliers.length,
                                              (index) => SimpleDialogOption(
                                                    onPressed: () {
                                                      purchaseController
                                                              .selectedSupplier
                                                              .value =
                                                          supplierController
                                                              .suppliers
                                                              .elementAt(index)
                                                              .fullName!;
                                                      purchaseController
                                                              .selectedSupplierId
                                                              .value =
                                                          supplierController
                                                              .suppliers
                                                              .elementAt(index)
                                                              .id!;
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "${supplierController.suppliers.elementAt(index).fullName}"),
                                                  )),
                                        );
                                      });
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.black, width: 2)),
                                child: Row(
                                  children: [
                                    Obx(() {
                                      return majorTitle(
                                          title: purchaseController
                                              .selectedSupplier.value,
                                          color: Colors.black,
                                          size: 12.0);
                                    }),
                                    Spacer(),
                                    Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: majorTitle(
                          title: "Cancel", color: Colors.black, size: 16.0)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        purchaseController.createPurchase(
                            shopId: shopController.currentShop.value!.id,
                            attendantid: authController.currentUser.value!.id,
                            screen: "admin",
                            context: context);
                      },
                      child: majorTitle(
                          title: "Okay", color: Colors.black, size: 16.0))
                ],
              ),
            );
          });
    }
  }
}
