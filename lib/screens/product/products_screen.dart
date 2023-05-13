// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/product_model.dart';
import 'package:get/get.dart';

import '../../controllers/attendant_controller.dart';
import '../../models/receipt_item.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../sales/components/product_select.dart';

class ProductsScreen extends StatelessWidget {
  final type;
  final shopId;
  Function? function;

  ProductsScreen(
      {Key? key, required this.type, required this.shopId, this.function})
      : super(key: key);
  AttendantController attendantController = Get.find<AttendantController>();
  SalesController salesController = Get.find<SalesController>();
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    productController.getProductsBySort(type: "all");
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
              : productController.products.isEmpty
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
                        return productCard(
                            product: productModel,
                            type: type,
                            function: (ProductModel product) {
                              ReceiptItem receiptItem = ReceiptItem(
                                  product: product,
                                  price: product.selling,
                                  total: product.selling,
                                  quantity: 1,
                                  discount: 0);
                              print(product.discount);
                              salesController.changesaleItem(receiptItem);
                              Get.back();
                            });
                      });
        },
      ),
    );
  }
}
