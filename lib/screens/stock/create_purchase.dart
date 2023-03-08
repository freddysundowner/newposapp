import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/responsive/large_screen.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/create_customers.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/purchase_controller.dart';
import '../../controllers/supplierController.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/purchases_card.dart';
import '../../widgets/smalltext.dart';
import '../product/product_selection.dart';
import '../sales/components/product_select.dart';

class CreatePurchase extends StatelessWidget {
  CreatePurchase({Key? key}) : super(key: key);
  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();
  AuthController authController = Get.find<AuthController>();
  ProductController productController = Get.find<ProductController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    supplierController.getSuppliersInShop(shopController.currentShop.value?.id);
    return WillPopScope(
      onWillPop: () async {
        purchaseController.selectedList.clear();
        return true;
      },
      child: ResponsiveWidget(
          largeScreen: Scaffold(
            endDrawer: Drawer(
              child: Center(
                child: Obx(
                  () {
                    return productController.getProductLoad.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : productController.products.length == 0
                            ? Center(
                                child: minorTitle(
                                    title:
                                        "This shop doesn't have products yet",
                                    color: Colors.black),
                              )
                            : ListView.builder(
                                itemCount: productController.products.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  ProductModel productModel = productController
                                      .products
                                      .elementAt(index);
                                  return shopcard(
                                      product: productModel, type: "purchase");
                                });
                  },
                ),
              ),
            ),
            key: _scaffoldKey,
            body: LargeScreen(
                body: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      majorTitle(
                          title: "Make New Sale",
                          color: Colors.black,
                          size: 18.0),
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: Row(
                          children: [
                            majorTitle(
                                title: "Choose Product",
                                color: Colors.black,
                                size: 13.0),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(() {
                  return purchaseController.selectedList.length == 0
                      ? noItemsFound(context, true)
                      : Container(
                          height: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: purchaseController.selectedList.length,
                              itemBuilder: (context, index) {
                                ProductModel productModel = purchaseController
                                    .selectedList
                                    .elementAt(index);
                                return purchasesCard(
                                    context: context,
                                    productModel: productModel,
                                    index: index);
                              }),
                        );
                }),
                SizedBox(
                  height: 20,
                ),
                Obx(() {
                  return purchaseController.selectedList.length > 0
                      ? Container(width: 200, child: saveButton(context))
                      : Container();
                }),
              ],
            )),
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
                                    ProductModel productModel =
                                        purchaseController.selectedList
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
                                          border:
                                              Border.all(color: Colors.grey),
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
          )),
    );
  }

  Widget saveButton(context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
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
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        minorTitle(
                                            title: "Amount ",
                                            color: Colors.black),
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
                                              purchaseController.balance.value =
                                                  0;
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
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        majorTitle(
                                            title: "Balance",
                                            color: Colors.black,
                                            size: 13.0),
                                        Obx(() {
                                          return minorTitle(
                                              title: purchaseController
                                                  .balance.value,
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
                                    if (supplierController.suppliers.length ==
                                        0) {
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
                                                                  .elementAt(
                                                                      index)
                                                                  .fullName!;
                                                          purchaseController
                                                                  .selectedSupplierId
                                                                  .value =
                                                              supplierController
                                                                  .suppliers
                                                                  .elementAt(
                                                                      index)
                                                                  .id!;
                                                          Navigator.pop(
                                                              context);
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
                              title: "Cancel",
                              color: Colors.black,
                              size: 16.0)),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            purchaseController.createPurchase(
                                shopId: shopController.currentShop.value!.id,
                                attendantid:
                                    authController.currentUser.value!.id,
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
}
