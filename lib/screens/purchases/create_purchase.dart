import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/screens/purchases/all_purchases.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/search_widget.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/purchase_controller.dart';
import '../../controllers/supplierController.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/alert.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/purchases_card.dart';
import '../../widgets/smalltext.dart';
import '../home/home_page.dart';
import '../product/products_screen.dart';
import '../suppliers/create_suppliers.dart';

class CreatePurchase extends StatelessWidget {
  CreatePurchase({Key? key}) : super(key: key) {
    supplierController.getSuppliersInShop("all");
  }

  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();
  AuthController authController = Get.find<AuthController>();
  ProductController productController = Get.find<ProductController>();
  UserController usercontroller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          purchaseController.invoice.value?.items.clear();
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            titleSpacing: 0.0,
            leading: IconButton(
                onPressed: () {
                  purchaseController.invoice.value = null;

                  if (isSmallScreen(context)) {
                    Get.back();
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        StockPage();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title: majorTitle(
                title: "Add Purchase", color: Colors.black, size: 20.0),
            actions: [
              if (!isSmallScreen(context) &&
                  purchaseController.invoice.value != null)
                InkWell(
                  onTap: () async {
                    purchaseController.invoice.value?.supplier == null;
                    saveFunction(context);
                  },
                  child: Container(
                    height: kToolbarHeight * 0.5,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    margin: const EdgeInsets.symmetric(vertical: 10)
                        .copyWith(right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainColor),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Create Purchase",
                      style: TextStyle(color: AppColors.mainColor),
                    ),
                  ),
                )
            ],
          ),
          body: Stack(
            children: [
              Obx(() {
                return purchaseController.invoice.value == null
                    ? Center(
                        child: minorTitle(
                            title: "No Items selected to purchase in",
                            color: Colors.black),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: kToolbarHeight * 1.2,
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: purchaseController
                                    .invoice.value!.items.length,
                                itemBuilder: (context, index) {
                                  InvoiceItem invoiceItem = purchaseController
                                      .invoice.value!.items
                                      .elementAt(index);
                                  return purchasesItemCard(
                                      invoiceItem: invoiceItem, index: index);
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
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    productController.getProductsBySort(
                                      type: "all",
                                    );
                                    if (isSmallScreen(context)) {
                                      Get.to(() => ProductsScreen(
                                            type: "purchase",
                                          ));
                                    } else {
                                      Get.find<HomeController>()
                                          .selectedWidget
                                          .value = ProductsScreen(
                                        type: "purchase",
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Row(
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
                              if (usercontroller.user.value?.usertype ==
                                      "admin" &&
                                  isSmallScreen(context))
                                IconButton(
                                    onPressed: () {
                                      purchaseController.scanQR(
                                          shopId: shopController
                                              .currentShop.value?.id,
                                          context: context);
                                    },
                                    icon: const Icon(Icons.qr_code))
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          bottomNavigationBar: Obx(() {
            return BottomAppBar(
              color: Colors.white,
              child: purchaseController.invoice.value == null
                  ? Container(height: 0)
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      height:
                          isSmallScreen(context) ? kToolbarHeight * 1.5 : 0.0,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: createPurchase(context),
                    ),
            );
          }),
        ));
  }

  Widget createPurchase(context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        purchaseController.invoice.value?.supplier == null;
        saveFunction(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
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
    if (purchaseController.invoice.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select products to sell")));
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor:
            isSmallScreen(context) ? Colors.white : Colors.transparent,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(
                  left: isSmallScreen(context)
                      ? 0
                      : MediaQuery.of(context).size.width * 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              minorTitle(
                                  title: "Amount paid", color: Colors.black),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                autofocus: true,
                                controller: purchaseController
                                    .textEditingControllerAmount,
                                onChanged: (value) {
                                  purchaseController.calculateAmount();
                                  purchaseController.invoice.refresh();
                                  print(value);
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    prefix: Text(
                                        "${shopController.currentShop.value?.currency!} ")),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              majorTitle(
                                  title: "Total",
                                  color: Colors.black,
                                  size: 13.0),
                              const SizedBox(
                                height: 3,
                              ),
                              Obx(() {
                                return minorTitle(
                                    title: htmlPrice(purchaseController
                                        .invoice.value?.total),
                                    color: Colors.grey,
                                    size: 14);
                              }),
                              const SizedBox(
                                height: 8,
                              ),
                              majorTitle(
                                  title: purchaseController.balanceText,
                                  color: Colors.black,
                                  size: 13.0),
                              const SizedBox(
                                height: 3,
                              ),
                              Obx(() {
                                return minorTitle(
                                    title: htmlPrice(
                                        purchaseController.balance.abs()),
                                    color: Colors.grey,
                                    size: 11);
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                    if (purchaseController.invoice.value?.supplier == null)
                      const SizedBox(
                        height: 10,
                      ),
                    if (purchaseController.invoice.value?.supplier == null)
                      InkWell(
                        onTap: () {
                          if (isSmallScreen(context)) {
                            Get.to(() => _gotoSupplierPage(context));
                          } else {
                            Get.back();
                            Get.find<HomeController>().selectedWidget.value =
                                _gotoSupplierPage(context);
                          }
                        },
                        child: majorTitle(
                            title: "Choose Supplier",
                            color: AppColors.mainColor,
                            size: 18.0),
                      ),
                    if (purchaseController.invoice.value?.supplier != null)
                      const SizedBox(
                        height: 10,
                      ),
                    Row(
                      children: [
                        if (purchaseController.invoice.value?.supplier != null)
                          InkWell(
                            onTap: () {
                              _gotoSupplierPage(context);
                            },
                            child: Row(
                              children: [
                                Obx(
                                  () => majorTitle(
                                      title: purchaseController
                                          .invoice.value!.supplier?.fullName,
                                      color: AppColors.mainColor,
                                      size: 18.0),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (isSmallScreen(context)) {
                                      Get.to(() => _gotoSupplierPage(context));
                                    } else {
                                      Get.back();
                                      Get.find<HomeController>()
                                          .selectedWidget
                                          .value = _gotoSupplierPage(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            (BorderRadius.circular(10)),
                                        border: Border.all(
                                            color: AppColors.mainColor,
                                            width: 1)),
                                    child: Row(
                                      children: [
                                        majorTitle(
                                            title: "Change",
                                            color: Colors.red,
                                            size: 12.0),
                                        const Icon(
                                          Icons.edit,
                                          size: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        if (purchaseController.invoice.value?.supplier != null)
                          IconButton(
                              onPressed: () {
                                purchaseController.invoice.value?.supplier =
                                    null;
                                purchaseController.invoice.refresh();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: majorTitle(
                                title: "Cancel",
                                color: Colors.red,
                                size: 16.0)),
                        const SizedBox(width: 30),
                        TextButton(
                            onPressed: () {
                              if (purchaseController.invoice.value!.balance! >
                                      0 &&
                                  purchaseController.invoice.value!.supplier ==
                                      null) {
                                generalAlert(
                                    title: "Error",
                                    message: "please select supplier");
                              } else {
                                purchaseController.createPurchase();
                              }
                            },
                            child: majorTitle(
                                title: "Cash in",
                                color: AppColors.mainColor,
                                size: 16.0)),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Scaffold _gotoSupplierPage(context) {
    print("hello");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            if (isSmallScreen(Get.context)) {
              Get.back();
            } else {
              Get.find<HomeController>().selectedWidget.value =
                  CreatePurchase();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(title: "Supplier", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${Get.find<ShopController>().currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
        actions: [
          if (checkPermission(category: "suppliers", permission: "add"))
            InkWell(
              onTap: () {
                if (isSmallScreen(Get.context)) {
                  Get.to(() => CreateSuppliers(
                        page: "createPurchase",
                      ));
                } else {
                  print("hello");
                  Get.find<HomeController>().selectedWidget.value =
                      CreateSuppliers(
                    page: "createPurchase",
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: (BorderRadius.circular(10)),
                      border: Border.all(color: AppColors.mainColor, width: 1)),
                  child: Center(
                    child: majorTitle(
                        title: "Add Supplier",
                        color: AppColors.mainColor,
                        size: 12.0),
                  ),
                ),
              ),
            )
        ],
      ),
      body: Suppliers(
        type: "purchases",
        from: "all",
        function: () {
          saveFunction(Get.context);
        },
      ),
    );
  }
}
