import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../Real/Models/schema.dart';

Widget searchWidget(
    {required autoCompletKey,
    required focusNode,
    required shopId,
    required page}) {
  ProductController productController = Get.find<ProductController>();
  productController.products.clear();
  productController.products.refresh();
  return RawAutocomplete<Product>(
    key: autoCompletKey,
    focusNode: focusNode,
    textEditingController: productController.searchProductController,
    optionsBuilder: (TextEditingValue textEditingValue) async {
      if (productController.searchProductController.text.isNotEmpty) {
        await productController.getProductsBySort(
            type: "all", text: productController.searchProductController.text);
      }
      return productController.products;
    },
    fieldViewBuilder: (BuildContext context,
        TextEditingController textEditingController,
        FocusNode focusNode,
        VoidCallback onFieldSubmitted) {
      return TextField(
        decoration: InputDecoration(
          hintText: "Search Product..",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1)),
        ),
        controller: textEditingController,
        focusNode: focusNode,
      );
    },
    optionsViewBuilder: (BuildContext context,
        void Function(Product) onSelected, Iterable<Product> options) {
      return Material(
          child: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                  child: Column(
                children: options.map((opt) {
                  return InkWell(
                      onTap: () {
                        if (page == "purchase") {
                          // purchaseController.addNewPurchase(opt);
                          onSelected(opt);
                          productController.searchProductController.text = "";
                        } else {
                          onSelected(opt);
                          if (opt.quantity! <= 0) {
                            showSnackBar(
                                message: "Product out of stock",
                                color: Colors.red);
                            productController.searchProductController.text = "";
                          } else {
                            // salesController.changesaleItem(opt);
                            productController.searchProductController.text = "";
                          }
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.only(right: 60),
                          child: Card(
                              child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Text(opt.name!),
                          ))));
                }).toList(),
              ))));
    },
  );
}
