// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/sales/create_sale.dart';
import 'package:pointify/screens/sales/sale_order_item.dart';
import 'package:realm/realm.dart';

import '../../Real/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/user_controller.dart';
import '../../services/product.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/no_items_found.dart';
import '../../widgets/smalltext.dart';
import '../sales/components/product_select.dart';

class ProductsScreen extends StatelessWidget {
  final type;
  Function? function;

  ProductsScreen({Key? key, required this.type, this.function}) {}
  UserController attendantController = Get.find<UserController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  Widget searchWidget() {
    return TextFormField(
      controller: productController.searchProductController,
      onChanged: (value) {
        if (value == "") {
          productController.getProductsBySort(
            type: "all",
          );
        } else {
          productController.getProductsBySort(
              type: "search",
              text: productController.searchProductController.text);
        }
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
        suffixIcon: IconButton(
          onPressed: () {
            productController.getProductsBySort(
                type: "search",
                text: productController.searchProductController.text);
          },
          icon: Icon(Icons.search),
        ),
        hintText: "Quick Search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: majorTitle(
            title: "Select Product", color: Colors.black, size: 16.0),
        elevation: 0.5,
        leading: IconButton(
            onPressed: () {
              if (isSmallScreen(context)) {
                Get.back();
              } else {
                if (type == "sale") {
                  Get.find<HomeController>().selectedWidget.value =
                      CreateSale();
                }
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
      ),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: searchWidget()),
          Expanded(
            child: Obx(
              () => ListView.builder(
                  itemCount: productController.products.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Product productModel =
                        productController.products.elementAt(index);

                    return productListItemCard(
                        product: productModel,
                        type: type,
                        function: function != null
                            ? (Product product) {
                                return function!(product);
                              }
                            : (Product product) {
                                print("hello");
                                InvoiceItem invoiceItem = InvoiceItem(
                                    ObjectId(),
                                    product: product,
                                    price: product.buyingPrice,
                                    total: product.buyingPrice,
                                    attendantid:
                                        Get.find<UserController>().user.value,
                                    createdAt: DateTime.now(),
                                    itemCount: 1);
                                Get.back();
                                purchaseController.addNewPurchase(invoiceItem);
                              });
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
