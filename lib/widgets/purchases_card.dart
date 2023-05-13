// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/screens/product/create_product.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import 'bigtext.dart';
import 'normal_text.dart';

Widget purchasesCard(
    {required context, required ProductModel productModel, required index}) {
  PurchaseController salesController = Get.find<PurchaseController>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              majorTitle(
                  title: "${productModel.name}",
                  color: Colors.black,
                  size: 16.0),
              IconButton(
                color: Colors.grey,
                icon: Icon(Icons.clear),
                onPressed: () {
                  salesController.removeFromList(index);
                },
              )
            ],
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                majorTitle(title: "Qty", color: Colors.black54, size: 13.0),
                SizedBox(height: 5),
                minorTitle(
                    title: "${productModel.quantity}", color: Colors.grey)
              ]),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      majorTitle(
                          title: "Unit S.Price",
                          color: Colors.black54,
                          size: 13.0),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      normalText(
                          title:
                              "${shopController.currentShop.value?.currency}.${productModel.buyingPrice}",
                          color: Colors.grey,
                          size: 14.0),
                      SizedBox(width: 10),
                      if (authController.usertype == "admin" ||
                          (authController.usertype == "attendant" &&
                              attendantController.checkRole("edit_entries")))
                        InkWell(
                            onTap: () {
                              Get.to(() => CreateProduct(
                                  page: "edit", productModel: productModel));
                            },
                            child: Text(
                              "Edit Price",
                              style: TextStyle(color: Colors.red),
                            )),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                IconButton(
                    onPressed: () {
                      salesController.decrementItem(index);
                    },
                    icon: Icon(Icons.remove, color: Colors.black, size: 16)),
                Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, right: 8, left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black, width: 0.1),
                      color: Colors.grey,
                    ),
                    child: majorTitle(
                        title: "${productModel.cartquantity}",
                        color: Colors.black,
                        size: 12.0)),
                IconButton(
                    onPressed: () {
                      salesController.incrementItem(index);
                    },
                    icon: Icon(Icons.add, color: Colors.black, size: 16)),
              ]),
              normalText(
                  title:
                      "Total=  ${shopController.currentShop.value?.currency}.${productModel.amount}",
                  color: Colors.black,
                  size: 17.0)
            ],
          )
        ]),
      ),
    ),
  );
}
