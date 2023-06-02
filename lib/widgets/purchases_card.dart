import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/Models/schema.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget purchasesItemCard({required InvoiceItem invoiceItem, required index}) {
  PurchaseController purchaseController = Get.find<PurchaseController>();
  UserController attendantController = Get.find<UserController>();
  UserController userController = Get.find<UserController>();
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
                  title: "${invoiceItem.product?.name}",
                  color: Colors.black,
                  size: 16.0),
              IconButton(
                color: Colors.grey,
                icon: Icon(Icons.clear),
                onPressed: () {
                  purchaseController.removeFromList(index);
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
                    title: "${invoiceItem.product?.quantity}",
                    color: Colors.grey)
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
                          title: htmlPrice(invoiceItem.product?.buyingPrice),
                          color: Colors.grey,
                          size: 14.0),
                      SizedBox(width: 10),
                      if (userController.user.value?.usertype == "admin" ||
                          (userController.user.value?.usertype == "attendant" &&
                              attendantController.checkRole("edit_entries")))
                        InkWell(
                            onTap: () {
                              // Get.to(() => CreateProduct(
                              //     page: "edit", productModel: productModel));
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
                      purchaseController.decrementItem(index);
                    },
                    icon: const Icon(Icons.remove,
                        color: Colors.black, size: 16)),
                Container(
                    width: 60,
                    height: 30,
                    child: TextFormField(
                      onChanged: (value) {
                        invoiceItem.itemCount = int.parse(value);
                        purchaseController.calculateAmount(index);
                      },
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        hintText: invoiceItem.itemCount.toString(),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                      ),
                    )),
                IconButton(
                    onPressed: () {
                      purchaseController.incrementItem(index);
                    },
                    icon: Icon(Icons.add, color: Colors.black, size: 16)),
              ]),
              normalText(
                  title: "Total=  ${htmlPrice(invoiceItem.price)}",
                  color: Colors.black,
                  size: 17.0)
            ],
          )
        ]),
      ),
    ),
  );
}
