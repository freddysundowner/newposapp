import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/widgets/pdf/bar_code_pdf.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/Models/schema.dart';
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
                      SizedBox(height: 5),
                      minorTitle(
                          title: "Category: ${product.category?.name}",
                          color: Colors.white),
                      SizedBox(height: 5),
                      minorTitle(
                          title: "Available: ${product.quantity}",
                          color: Colors.white),
                      SizedBox(height: 5),
                      minorTitle(
                          title: "By ~ ${product.attendant?.fullnames}",
                          color: Colors.white),
                    ],
                  )
                ],
              ),
              Spacer(),
              Row(children: [
                Column(
                  children: [
                    minorTitle(
                        title:
                            "BP/= ${shopController.currentShop.value?.currency}.${product.buyingPrice}",
                        color: Colors.white),
                    SizedBox(height: 5),
                    minorTitle(
                        title:
                            "SP/=  ${shopController.currentShop.value?.currency}.${product.selling}",
                        color: Colors.white),
                  ],
                ),
                SizedBox(width: 10),
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
                    leading: Icon(Icons.list),
                    onTap: () {
                      Get.back();
                      Get.to(() => ProductHistory(product: product));
                    },
                    title: const Text('Product History')),
              if (userController.user.value?.usertype == "admin" ||
                  (userController.user.value?.usertype == "attendant" &&
                      userController.checkRole("edit_entries")))
                ListTile(
                    leading: Icon(Icons.edit),
                    onTap: () {
                      Get.back();
                      Get.to(() => CreateProduct(
                            page: "edit",
                            productModel: product,
                          ));
                    },
                    title: Text('Edit')),
              if (userController.user.value?.usertype == "admin")
                ListTile(
                    leading: Icon(Icons.code),
                    onTap: () {
                      Get.back();
                      BarcodePdf(
                          productname: product.name,
                          shop: Get.find<ShopController>()
                              .currentShop
                              .value!
                              .name!);
                    },
                    title: const Text('Generate Barcode')),
              if (userController.user.value?.usertype == "admin" ||
                  (userController.user.value?.usertype == "attendant" &&
                      userController.checkRole("edit_entries")))
                ListTile(
                    leading: Icon(Icons.delete),
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
                    title: Text('Delete')),
              ListTile(
                  leading: Icon(Icons.clear),
                  onTap: () {
                    Get.back();
                  },
                  title: Text('Close')),
            ],
          ),
        );
      });
}
