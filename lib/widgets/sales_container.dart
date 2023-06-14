import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/sales/components/discount_dialog.dart';
import 'package:pointify/screens/sales/components/edit_price_dialog.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/schema.dart';
import '../controllers/AuthController.dart';
import '../controllers/sales_controller.dart';
import 'bigtext.dart';
import 'normal_text.dart';

Widget SalesContainer(
    {required ReceiptItem receiptItem, required index, required type}) {
  SalesController salesController = Get.find<SalesController>();
  TextEditingController textEditingController = TextEditingController();
  Product productModel = receiptItem.product!;
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: type == "small" ? double.infinity : 250,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  majorTitle(title: "Price", color: Colors.black54, size: 13.0),
                  SizedBox(height: 5),
                  minorTitle(
                      title: "${productModel.selling}", color: Colors.grey),
                ],
              ),
              SizedBox(width: 15),
              if (checkPermission(category: "sales", permission: "edit_price"))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title: "Action", color: Colors.black54, size: 13.0),
                    const SizedBox(height: 10),
                    InkWell(
                        onTap: () {
                          salesController.textEditingSellingPrice.text =
                              "${productModel.minPrice}";
                          showEditDialogPrice(
                              productModel: productModel, index: index);
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              Spacer(),
              if (checkPermission(category: "sales", permission: "discount"))
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      discountDialog(
                          controller: textEditingController,
                          receiptItem: receiptItem,
                          index: index);
                    },
                    child: receiptItem.discount! > 0
                        ? InkWell(
                            onTap: () {
                              receiptItem.discount = 0;
                              salesController.calculateAmount(index);
                            },
                            child: Row(
                              children: [
                                Text(
                                  htmlPrice(receiptItem.discount!),
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                                const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                  size: 14,
                                ),
                              ],
                            ))
                        : const Text(
                            "Discount",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.blue),
                          ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          type == "small"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      IconButton(
                          onPressed: () {
                            salesController.decrementItem(index);
                          },
                          icon: const Icon(Icons.remove,
                              color: Colors.black, size: 16)),
                      Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, right: 8, left: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black, width: 0.1),
                            color: Colors.grey,
                          ),
                          child: majorTitle(
                              title: "${receiptItem.quantity}",
                              color: Colors.black,
                              size: 12.0)),
                      IconButton(
                          onPressed: () {
                            salesController.incrementItem(index);
                          },
                          icon: Icon(Icons.add, color: Colors.black, size: 16)),
                    ]),
                    normalText(
                        title: htmlPrice(receiptItem.total),
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
                              icon: const Icon(Icons.remove,
                                  color: Colors.black, size: 16)),
                          Container(
                              padding: const EdgeInsets.only(
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
                              icon: const Icon(Icons.add,
                                  color: Colors.black, size: 16)),
                        ]),
                    normalText(
                        title: htmlPrice(receiptItem.total),
                        color: Colors.black,
                        size: 17.0)
                  ],
                )
        ]),
      ),
    ),
  );
}
