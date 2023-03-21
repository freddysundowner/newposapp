import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/widgets/pdf/bar_code_pdf.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../screens/product/create_product.dart';
import '../screens/product/product_history.dart';
import '../utils/colors.dart';
import 'bigtext.dart';
import 'delete_dialog.dart';

Widget productCard(
    {required context, required ProductModel product, required shopId}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      showProductModal(context, product, shopId);
    },
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: product.quantity == 0
            ? Colors.red
            : product.quantity == product.stockLevel
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
                            "SP/=  ${shopController.currentShop.value?.currency}.${product.sellingPrice![0]}",
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

showProductModal(context, ProductModel product, shopId) {
  ProductController productController = Get.find<ProductController>();
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();

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
              if (authController.usertype == "admin")
                ListTile(
                    leading: Icon(Icons.list),
                    onTap: () {
                      Get.back();
                      Get.to(() => ProductHistory(product: product));
                    },
                    title: Text('Product History')),
              if (authController.usertype == "admin" ||
                  (authController.usertype == "attendant" &&
                      attendantController.checkRole("edit_entries")))
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
              if (authController.usertype == "admin")
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
