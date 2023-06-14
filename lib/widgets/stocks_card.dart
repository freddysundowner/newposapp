// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Real/schema.dart';
import '../utils/colors.dart';

Widget stockCard(
    {required context,
    required InvoiceItem supplyOrderModel,
    required type,
    String? purchaseId}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      showProductModal(context, supplyOrderModel, type, purchaseId: purchaseId);
    },
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 5,
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${supplyOrderModel.product!.name}"),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                              'Qty ${supplyOrderModel.itemCount} @${shopController.currentShop.value?.currency}.${supplyOrderModel.product!.buyingPrice}'),
                          SizedBox(width: 5),
                          Text(
                            "Total :${shopController.currentShop.value?.currency}.${supplyOrderModel.itemCount! * supplyOrderModel.product!.buyingPrice!}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(DateFormat('yyyy-MM-dd hh:mm a')
                              .format(supplyOrderModel.createdAt!)
                              .toString()),
                          Text(
                              ", by: ${supplyOrderModel.attendantid?.username}"),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Row(children: [
                Text(""),
                SizedBox(
                  height: 5,
                ),
                Text(""),
                SizedBox(
                  height: 5,
                ),
                Icon(
                  Icons.more_vert_rounded,
                  color: Colors.black,
                  size: 20,
                )
              ])
            ],
          )),
        ),
      ),
    ),
  );
}

showProductModal(context, InvoiceItem supplyOrderModel, type, {purchaseId}) {
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                ListTile(
                  title: Text("Return to supplier"),
                  leading: Icon(Icons.recycling),
                  onTap: () {
                    // if (supplyOrderModel.supplier == null) {
                    //   generalAlert(
                    //       title: "Error!",
                    //       message: "No supplier to return item to");
                    // } else {
                    //   Get.back();
                    //   Get.find<SupplierController>().returnOrderToSupplier(
                    //       uid: supplyOrderModel.id, purchaseId: purchaseId);
                    // }
                  },
                ),
              ],
            ));
      });
}

showQuantityDialog(context, InvoiceItem supplyOrderModel) {
  PurchaseController purchaseController = Get.find<PurchaseController>();
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width:
                MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
            padding: EdgeInsets.fromLTRB(10, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Quantity to return"),
                SizedBox(height: 10),
                TextFormField(
                  controller: purchaseController.textEditingControllerAmount,
                  decoration: InputDecoration(
                      hintText: "Quantity",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (purchaseController
                                .textEditingControllerAmount.text.isEmpty ||
                            int.parse(purchaseController
                                    .textEditingControllerAmount.text) >
                                supplyOrderModel.itemCount!) {
                          showSnackBar(
                              message: "Enter a valid amount",
                              color: Colors.redAccent);
                        } else {}
                      },
                      child: Text(
                        "Save Now".toUpperCase(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
