// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/screens/sales/components/edit_price_dialog.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../controllers/sales_controller.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget SalesContainer(
    {required context,
    required ProductModel productModel,
    required index,
    required type}) {
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  TextEditingController textEditingController = TextEditingController();
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(8.0),
        width: type=="small"?double.infinity:250,
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
                      minorTitle(
                          title: "${productModel.selling}", color: Colors.grey),
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () {
                            salesController.textEditingSellingPrice.text =
                                "${productModel.minPrice}";
                            showEditDialogPrice(context: context, productModel: productModel, index: index);
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          // if (Get.find<AuthController>().currentUser.value?.type ==
          //             "attendant" &&
          //         Get.find<AuthController>().checkRole("cangivediscounts") ==
          //             true ||
          //     Get.find<AuthController>().currentUser.value?.type == "admin")
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Add Discount"),
                        content: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: TextFormField(
                              controller: textEditingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "0",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ))),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              if (int.parse(textEditingController.text) >
                                  (productModel.discount! *
                                      productModel.cartquantity!)) {
                                showSnackBar(
                                    message:
                                        "discount cannot be greater than ${productModel.discount! * productModel.cartquantity!}",
                                    color: Colors.red,
                                    context: context);
                              } else {
                                productModel.allowedDiscount =
                                    int.parse(textEditingController.text);
                                textEditingController.text = "";
                                salesController.calculateAmount(index);
                              }
                            },
                            child: Text(
                              "Save now".toUpperCase(),
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      );
                    });
              },
              child: Text(
                "Discount",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
          type == "small"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            salesController.decrementItem(index);
                          },
                          icon: Icon(Icons.remove,
                              color: Colors.black, size: 16)),
                      Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, right: 8, left: 8),
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
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                salesController.decrementItem(index);
                              },
                              icon: Icon(Icons.remove,
                                  color: Colors.black, size: 16)),
                          Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, right: 8, left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: Colors.black, width: 0.1),
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
                              icon: Icon(Icons.add,
                                  color: Colors.black, size: 16)),
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
