// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';

import '../../controllers/attendant_controller.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../sales/components/product_select.dart';

class ProductSelection extends StatelessWidget {
  final type;
  final shopId;

  ProductSelection({Key? key, required this.type, required this.shopId})
      : super(key: key);
  AttendantController attendantController = Get.find<AttendantController>();
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    productController.getProductsBySort(
        shopId: "${shopController.currentShop.value?.id}", type: "all");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: majorTitle(
            title: "Select Product", color: Colors.black, size: 16.0),
        elevation: 0.5,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
      ),
      body: Obx(
        () {
          return productController.getProductLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : productController.products.length == 0
                  ? Center(
                      child: minorTitle(
                          title: "This shop doesn't have products yet",
                          color: Colors.black),
                    )
                  : ListView.builder(
                      itemCount: productController.products.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        ProductModel productModel =
                            productController.products.elementAt(index);
                        return shopcard(product: productModel, type: type);
                      });
        },
      ),
    );
  }
}
