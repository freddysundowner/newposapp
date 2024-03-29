import 'package:flutter/material.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/schema.dart';
import '../functions/functions.dart';
import '../screens/product/create_product.dart';
import '../screens/product/product_history.dart';
import '../utils/colors.dart';
import 'bigtext.dart';
import 'delete_dialog.dart';

Widget productCard({required Product product}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      showProductModal(Get.context!, product);
    },
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: product.quantity == 0
            ? Colors.red
            : product.quantity! <= product.stockLevel!
                ? Colors.amber
                : AppColors.mainColor,
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      majorTitle(
                          title: "${product.name}",
                          color: Colors.white,
                          size: 16.0),
                      const SizedBox(height: 5),
                      minorTitle(
                          title: "Category: ${product.category?.name}",
                          color: Colors.white),
                      const SizedBox(height: 5),
                      minorTitle(
                          title: "Available: ${product.quantity}",
                          color: Colors.white),
                      const SizedBox(height: 5),
                      minorTitle(
                          title: "By ~ ${product.attendant?.username}",
                          color: Colors.white),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Row(children: [
                Column(
                  children: [
                    minorTitle(
                        title:
                            "BP/= ${shopController.currentShop.value?.currency}.${product.buyingPrice}",
                        color: Colors.white),
                    const SizedBox(height: 5),
                    minorTitle(
                        title:
                            "SP/=  ${shopController.currentShop.value?.currency}.${product.selling}",
                        color: Colors.white),
                  ],
                ),
                const SizedBox(width: 10),
              ])
            ],
          )),
        ),
      ),
    ),
  );
}

showProductModal(context, Product product) {
  ProductController productController = Get.find<ProductController>();
  UserController userController = Get.find<UserController>();
  SalesController salesController = Get.find<SalesController>();

  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Container(child: Text('Manage ${product.name}'))],
                ),
              ),
              if (userController.user.value?.usertype == "admin")
                ListTile(
                    leading: const Icon(Icons.list),
                    onTap: () {
                      Get.back();

                      getYearlyRecords(product, function: (Product product,
                          DateTime firstday, DateTime lastday) {
                        salesController.filterStartDate.value = firstday;
                        salesController.filterEndDate.value = lastday;
                        salesController.getSalesByProductId(
                            product: product,
                            fromDate: firstday,
                            toDate: lastday);
                        productController.getProductPurchaseHistory(product,
                            fromDate: firstday, toDate: lastday);
                      }, year: salesController.currentYear.value);

                      Get.to(() => ProductHistory(product: product));
                    },
                    title: const Text('Product History')),
              if (checkPermission(category: "products", permission: "manage"))
                ListTile(
                    leading: const Icon(Icons.edit),
                    onTap: () {
                      Get.back();
                      Get.to(() => CreateProduct(
                            page: "edit",
                            productModel: product,
                          ));
                    },
                    title: const Text('Edit')),
              if (userController.user.value?.usertype == "admin")
                ListTile(
                    leading: const Icon(Icons.code),
                    onTap: () {
                      Get.back();
                      // BarcodePdf(
                      //     productname: product.name,
                      //     shop: Get.find<ShopController>()
                      //         .currentShop
                      //         .value!
                      //         .name!);
                    },
                    title: const Text('Generate Barcode')),
              if (checkPermission(category: "products", permission: "manage"))
                ListTile(
                    leading: const Icon(Icons.delete),
                    onTap: () {
                      Get.back();
                      deleteDialog(
                          context: context,
                          onPressed: () {
                            productController.deleteProduct(
                              product: product,
                            );
                          });
                    },
                    title: const Text('Delete')),
              ListTile(
                  leading: const Icon(Icons.clear),
                  onTap: () {
                    Get.back();
                  },
                  title: const Text('Close')),
            ],
          ),
        );
      });
}
