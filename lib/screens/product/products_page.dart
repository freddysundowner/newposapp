import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/product/product_history.dart';
import 'package:flutterpos/screens/stock/stock_page.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/product_card.dart';
import '../../widgets/smalltext.dart';
import 'create_product.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key? key}) : super(key: key) {
    productController.searchProductController.text = "";
    productController.getProductsBySort(
        shopId: "${createShopController.currentShop.value?.id}",
        type: productController.selectedSortOrderSearch.value);
  }

  ShopController createShopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        productController.getProductsBySort(
            shopId: "${createShopController.currentShop.value?.id}",
            type: "all");
        return true;
      },
      child: ResponsiveWidget(
          largeScreen: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.3,
              titleSpacing: 0.0,
              centerTitle: false,
              leading: authController.usertype == "attendant"
                  ? null
                  : IconButton(
                      onPressed: () {
                        if (MediaQuery.of(context).size.width > 600) {
                          Get.find<HomeController>().selectedWidget.value =
                              StockPage();
                        } else {
                          Get.back();
                        }
                        productController.getProductsBySort(
                            shopId:
                                "${createShopController.currentShop.value?.id}",
                            type: "all");
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        majorTitle(
                            title: "Shop Products",
                            color: Colors.black,
                            size: 16.0),
                        minorTitle(
                            title:
                                "${createShopController.currentShop.value?.name}",
                            color: Colors.grey)
                      ],
                    ),
                  ),
                  Spacer(),
                  if (authController.usertype=="attendant")
                    InkWell(
                        onTap: () {
                          Get.find<HomeController>().selectedWidget.value =
                              CreateProduct(
                                  page: "create", productModel: ProductModel());
                        },
                        child: majorTitle(
                            title: "Add Product",
                            color: AppColors.mainColor,
                            size: 16.0))
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 1, right: 10, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          searchWidget(),
                          SizedBox(width: 100),
                          sortWidget(context)
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Obx(() {
                      return productController.getProductLoad.value
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : productController.products.length == 0
                              ? Center(
                                  child: Text(
                                  "No Entries found",
                                  style: TextStyle(color: AppColors.mainColor),
                                ))
                              : Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.grey),
                                  child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        right: 10, left: 5, bottom: 20),
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
                                            label: Text('Category',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Available',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Buying Price',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Selling Price',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          productController.products.length,
                                          (index) {
                                        ProductModel productBody =
                                            productController.products
                                                .elementAt(index);
                                        final y = productBody.name;
                                        final x = productBody.category!.name;
                                        final w = productBody.quantity;
                                        final z = productBody.buyingPrice;
                                        final a = productBody.sellingPrice![0];

                                        return DataRow(cells: [
                                          DataCell(Container(
                                              width: 75, child: Text(y!))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(x.toString()))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(w.toString()))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(z.toString()))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(a.toString()))),
                                          DataCell(Align(
                                            child: InkWell(
                                              onTap: () {
                                                productOperions(
                                                    context,
                                                    productBody,
                                                    createShopController
                                                        .currentShop.value!.id);
                                              },
                                              child: Container(
                                                  width: 75,
                                                  child: Center(
                                                      child: Icon(
                                                          Icons.more_vert))),
                                            ),
                                            alignment: Alignment.topRight,
                                          )),
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
          ),
          smallScreen: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.3,
              titleSpacing: 0.0,
              centerTitle: false,
              leading: IconButton(
                onPressed: () {
                  productController.getProductsBySort(
                      shopId: "${createShopController.currentShop.value?.id}",
                      type: "all");
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        majorTitle(
                            title: "Shop Products",
                            color: Colors.black,
                            size: 16.0),
                        minorTitle(
                            title:
                                "${createShopController.currentShop.value?.name}",
                            color: Colors.grey)
                      ],
                    ),
                    Spacer(),
                    if (authController.usertype.value == "attendant")
                      InkWell(
                          onTap: () {
                            Get.to(() => CreateProduct(
                                page: "create", productModel: ProductModel()));
                          },
                          child: majorTitle(
                              title: "Add Product",
                              color: AppColors.mainColor,
                              size: 16.0))
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        searchWidget(),
                        if(authController.usertype=="admin")
                        IconButton(
                            onPressed: () async {
                              productController.scanQR(
                                  shopId: createShopController
                                              .currentShop.value ==
                                          null
                                      ? ""
                                      : "${createShopController.currentShop.value?.id}",
                                  type: "product",
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
                        Text("Sort List By"),
                        sortWidget(context),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    return productController.getProductLoad.value
                        ? Center(child: CircularProgressIndicator())
                        : productController.products.length == 0
                            ? Center(
                                child: Text(
                                "No Entries found",
                                style: TextStyle(color: AppColors.mainColor),
                              ))
                            : Container(
                                // height: MediaQuery.of(context).size.height*0.6,
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: productController.products.length,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    ProductModel productModel =
                                        productController.products
                                            .elementAt(index);
                                    return productCard(
                                        shopId:
                                            "${createShopController.currentShop.value!.id}",
                                        context: context,
                                        product: productModel);
                                  }),
                                ),
                              );
                  }),
                  SizedBox(height: 20),
                ],
              ),
            ),
          )),
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
                  Constants().sortOrder.length,
                  (index) => SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                          productController.selectedSortOrder.value =
                              Constants().sortOrder.elementAt(index);
                          productController.selectedSortOrderSearch.value =
                              Constants().sortOrderList.elementAt(index);
                          productController.getProductsBySort(
                              shopId:
                                  "${createShopController.currentShop.value!.id}",
                              type: productController
                                  .selectedSortOrderSearch.value);
                        },
                        child: Text(
                          Constants().sortOrder.elementAt(index),
                        ),
                      )),
            );
          },
        );
      },
      child: Row(
        children: [
          Obx(() {
            return Text(productController.selectedSortOrder.value,
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

  productOperions(context, product, shopId) {
    return showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          children: [
            if (authController.usertype == "admin")
              ListTile(
                leading: Icon(Icons.list),
                onTap: () {
                  Get.back();
                  Get.find<HomeController>().selectedWidget.value =
                      ProductHistory(product: product);
                },
                title: Text("Product History"),
              ),
            if (authController.usertype == "admin" ||
                (authController.usertype == "attendant" &&
                    attendantController.checkRole("edit_entries")))
              ListTile(
                  leading: Icon(Icons.edit),
                  title: Text("Edit"),
                  onTap: () {
                    Get.back();
                    Get.find<HomeController>().selectedWidget.value =
                        CreateProduct(page: "edit", productModel: product);
                  }),
            if (authController.usertype == "admin")
              ListTile(
                  leading: Icon(Icons.code),
                  onTap: () {
                    Get.back();
                  },
                  title: Text('Generate Barcode')),
            if (authController.usertype == "admin" ||
                (authController.usertype == "attendant" &&
                    attendantController.checkRole("edit_entries")))
              ListTile(
                leading: Icon(Icons.delete),
                onTap: () {
                  Get.back();
                  deleteDialog(
                      context: context,
                      onPressed: () {
                        productController.deleteProduct(
                            id: product.id, context: context, shopId: shopId);
                      });
                },
                title: Text("Delete"),
              ),
            ListTile(
              leading: Icon(Icons.clear),
              onTap: () {
                Get.back();
             },
              title: Text("Close"),
            )
          ],
        );
      },
    );
  }

  Widget searchWidget() {
    return Expanded(
      child: TextFormField(
        controller: productController.searchProductController,
        onChanged: (value) {
          if (value == "") {
            productController.products.clear();
          } else {
            productController.searchProduct(
                createShopController.currentShop.value == null
                    ? ""
                    : "${createShopController.currentShop.value!.id}",
                "product");
          }
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
          suffixIcon: IconButton(
            onPressed: () {
              productController.searchProduct(
                  createShopController.currentShop.value == null
                      ? ""
                      : "${createShopController.currentShop.value?.id}",
                  "product");
            },
            icon: Icon(Icons.search),
          ),
          hintText: "Quick Search Item",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
