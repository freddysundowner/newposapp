import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';


import '../../../../utils/Constants.dart';
import '../screens/product/product_history.dart';
import '../utils/colors.dart';
import 'bigtext.dart';
import 'delete_dialog.dart';

Widget productCard({required context, required product, required shopId}) {
  ShopController shopController=Get.find<ShopController>();
  return InkWell(
    onTap: () {
      showProductModal(context, product, shopId);
    },
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color:product.quantity == 0
            ? Colors.red
            :product.quantity == product.stockLevel? Colors.amber: AppColors.mainColor,
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
                              title: "Category: ${product.category.name}",
                              color: Colors.white),
                          SizedBox(height: 5),
                          minorTitle(
                              title: "Available: ${product.quantity}",
                              color: Colors.white),
                          SizedBox(height: 5),
                          minorTitle(
                              title: "By ~ ${product.attendant?.name}",
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
                            title: "BP/= ${shopController.currentShop.value?.currency}.${product.buyingPrice}",
                            color: Colors.white),
                        SizedBox(height: 5),
                        minorTitle(
                            title: "SP/=  ${shopController.currentShop.value?.currency}.${product.sellingPrice![0]}",
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
  ProductController productController=Get.find<ProductController>();

  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Container(child: Text('Manage ${product.name}'))],
                ),
              ),
              ListTile(
                  leading: Icon(Icons.list),
                  onTap: () {
                    Get.back();
                    Get.to(()=>ProductHistory(product:product));

                  },
                  title: Text('Product History')),
                ListTile(
                    leading: Icon(Icons.edit),
                    onTap: () {
                      Get.back();
                    },
                    title: Text('Edit')),
              ListTile(
                  leading: Icon(Icons.code),
                  onTap: () {
                    Get.back();

                  },
                  title: Text('Generate Barcode')),
                ListTile(
                    leading: Icon(Icons.delete),
                    onTap: () {
                      Get.back();
                      deleteDialog(
                          context: context,
                          onPressed: () {
                            productController.deleteProduct(id:product.id,context:context,shopId:shopId);
                          });
                    },
                    title: Text('Delete')),
            ],
          ),
        );
      });
}
