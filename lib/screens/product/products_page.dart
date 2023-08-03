import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/product_history.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/utils/constants.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
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
  }

  ShopController createShopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();
  AuthController authController = Get.find<AuthController>();
  UserController usercontroller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    print("productController.products ${productController.products.length}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0.0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            productController.getProductsBySort(type: "all");
            if (!isSmallScreen(context)) {
              Get.find<HomeController>().selectedWidget.value = StockPage();
            } else {
              Get.back();
            }
          },
          icon: const Icon(
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
                      title: "Products", color: Colors.black, size: 16.0),
                  minorTitle(
                      title: "${createShopController.currentShop.value?.name}",
                      color: Colors.grey)
                ],
              ),
              const Spacer(),
              if (usercontroller.user.value?.usertype == "attendant")
                InkWell(
                    onTap: () {
                      isSmallScreen(context)
                          ? Get.to(() =>
                              CreateProduct(page: "create", productModel: null))
                          : Get.find<HomeController>().selectedWidget.value =
                              CreateProduct(page: "create", productModel: null);
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
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: productController.searchProductController,
                      onChanged: (value) {
                        if (value == "") {
                          productController.getProductsBySort(
                            type: "all",
                          );
                        } else {
                          productController.getProductsBySort(
                              type: "search",
                              text: productController
                                  .searchProductController.text);
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        suffixIcon: IconButton(
                          onPressed: () {
                            productController.getProductsBySort(
                                type: "search",
                                text: productController
                                    .searchProductController.text);
                          },
                          icon: const Icon(Icons.search),
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
                  ),
                  if (usercontroller.user.value?.usertype == "admin" &&
                      isSmallScreen(context))
                    IconButton(
                        onPressed: () async {
                          productController.scanQR(
                              shopId: createShopController.currentShop.value ==
                                      null
                                  ? ""
                                  : "${createShopController.currentShop.value?.id}",
                              type: "product",
                              context: context);
                        },
                        icon: const Icon(Icons.qr_code))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sort List By"),
                  sortWidget(context),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return productController.getProductLoad.value
                  ? const Center(child: CircularProgressIndicator())
                  : productController.products.isEmpty
                      ? Center(
                          child: Text(
                          "No Entries found",
                          style: TextStyle(color: AppColors.mainColor),
                        ))
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: isSmallScreen(context)
                              ? ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: productController.products.length,
                                  shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    Product productModel = productController
                                        .products
                                        .elementAt(index);
                                    return productCard(product: productModel);
                                  }),
                                )
                              : Theme(
                                  data: Theme.of(context)
                                      .copyWith(dividerColor: Colors.grey),
                                  child: Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 5, bottom: 20),
                                    child: DataTable(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      )),
                                      columnSpacing: 30.0,
                                      columns: const [
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
                                            label: Text('Actions',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          productController.products.length,
                                          (index) {
                                        Product productBody = productController
                                            .products
                                            .elementAt(index);

                                        final y = productBody.name;
                                        final x = productBody.category?.name;
                                        final w = productBody.quantity;
                                        final z = productBody.buyingPrice;
                                        final a = productBody.selling;

                                        return DataRow(cells: [
                                          DataCell(Text(y!)),
                                          DataCell(Text(x.toString())),
                                          DataCell(Text(w.toString())),
                                          DataCell(Text(z.toString())),
                                          DataCell(Text(a.toString())),
                                          DataCell(Align(
                                            alignment: Alignment.topRight,
                                            child: PopupMenuButton(
                                              onSelected: (value) {
                                                switch (value) {
                                                  case "history":
                                                    {
                                                      Get.find<HomeController>()
                                                              .selectedWidget
                                                              .value =
                                                          ProductHistory(
                                                              product:
                                                                  productBody);
                                                    }
                                                    break;
                                                  case "edit":
                                                    {
                                                      Get.find<HomeController>()
                                                              .selectedWidget
                                                              .value =
                                                          CreateProduct(
                                                              page: "edit",
                                                              productModel:
                                                                  productBody);
                                                    }
                                                    break;
                                                  case "delete":
                                                    {
                                                      deleteDialog(
                                                          context: context,
                                                          onPressed: () {
                                                            productController
                                                                .deleteProduct(
                                                                    product:
                                                                        productBody);
                                                          });
                                                    }
                                                    break;
                                                  default:
                                                    break;
                                                }
                                                // your logic
                                              },
                                              itemBuilder: (BuildContext bc) {
                                                return productOperions(
                                                    context,
                                                    productBody,
                                                    createShopController
                                                        .currentShop.value!.id);
                                              },
                                            ),
                                          )),
                                        ]);
                                      }),
                                    ),
                                  ),
                                ),
                        );
            }),
            const SizedBox(height: 20),
          ],
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
                  Constants().sortOrder.length,
                  (index) => SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context);
                          productController.selectedSortOrder.value =
                              Constants().sortOrder.elementAt(index);
                          productController.selectedSortOrderSearch.value =
                              Constants().sortOrderList.elementAt(index);
                          productController.getProductsBySort(
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
    List<Map<String, dynamic>> data = [
      {"title": "Product History", "icon": Icons.list, "value": "history"},
      {"title": "Edit", "icon": Icons.edit, "value": "edit"},
      {"title": "Code", "icon": Icons.code, "value": "code"},
      {"title": "Delete", "icon": Icons.delete, "value": "delete"},
      {"title": "Cancel", "icon": Icons.clear, "value": "clear"},
    ];
    return data
        .map((e) => PopupMenuItem(
              value: e["value"],
              child:
                  ListTile(leading: Icon(e["icon"]), title: Text(e["title"])),
            ))
        .toList();
  }
}
