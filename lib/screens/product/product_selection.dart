// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';

import '../../controllers/attendant_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../controllers/stock_in_controller.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';


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
    productController.getProductsBySort(shopId: "${shopController.currentShop.value?.id}", type: "all");
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
        body: Obx(() {
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
                ProductModel productModel = productController.products.elementAt(index);
                return _shopcard(product: productModel, type: type);
              });
        }));
  }

  Widget _shopcard({required product, required type}) {
    SalesController salesController = Get.find<SalesController>();
    StockInController stockInController = Get.find<StockInController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
      child: InkWell(
        onTap: () {
          if (type == "product") {
            if (product.quantity <= 0) {
              Get.snackbar("", "Product is Already Out off Stock");
            } else {
              // attendantController.changeSelectedList(product);
              Get.back();
            }
          } else if (type == "stockIn") {
            // stockInController.changeSelectedList(product);
            Get.back();
          } else {
            if (product.quantity <= 0) {
              Get.snackbar("", "Product is Already Out off Stock");
            } else {
              salesController.selecteProduct.value = product;
              salesController.changeSelectedList(product);
              Get.back();
            }
          }
        },
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white.withOpacity(0.7),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${product.name}".capitalize!,
                  style: TextStyle(color: Colors.black, fontSize: 17),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "@ ${product.sellingPrice![0]} ${shopController.currentShop.value?.currency}, ${product.quantity} Left",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  product.category.name,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
