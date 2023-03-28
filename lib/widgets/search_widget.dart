import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

Widget searchWidget(
    {required autoCompletKey,
    required focusNode,
    required shopId,
    required page}) {
  ProductController productController = Get.find<ProductController>();
  SalesController salesController = Get.find<SalesController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  productController.products.clear();
  productController.products.refresh();
  return RawAutocomplete<ProductModel>(
    key: autoCompletKey,
    focusNode: focusNode,
    textEditingController: productController.searchProductController,
    optionsBuilder: (TextEditingValue textEditingValue) async {
      if (productController.searchProductController.text.isNotEmpty) {
        await productController.searchProduct("${shopId}", "product");
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
        void Function(ProductModel) onSelected,
        Iterable<ProductModel> options) {
      return Material(
          child: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                  child: Column(
                children: options.map((opt) {
                  return InkWell(
                      onTap: () {
                        if (page == "purchase") {
                          purchaseController.changeSelectedList(opt);
                          onSelected(opt);
                          productController.searchProductController.text = "";
                        } else {
                          onSelected(opt);
                          if (opt.quantity!<= 0) {
                            showSnackBar(message: "Product out of stock", color: Colors.red, context: context);
                            productController.searchProductController.text = "";
                          } else{
                            salesController.changeSelectedList(opt);
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
