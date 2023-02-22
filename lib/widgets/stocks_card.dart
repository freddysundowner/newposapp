// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/supply_order_model.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/supplierController.dart';
import '../utils/colors.dart';
import 'delete_dialog.dart';

Widget stockCard(
    {required context,
    required SupplyOrderModel supplyOrderModel,
    required type}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      if (supplyOrderModel.returned == false) {
        showProductModal(context, supplyOrderModel, type);
      }
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
                    child: supplyOrderModel.returned == true
                        ? ClipOval(
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(Icons.warning_amber_outlined,
                                  color: Colors.white),
                            ),
                          )
                        : ClipOval(
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
                      Text(
                          'Qty ${supplyOrderModel.quantity} @${shopController.currentShop.value?.currency}.${supplyOrderModel.product!.sellingPrice![0]}'),
                      SizedBox(height: 5),
                      Text(
                        "Total :${shopController.currentShop.value?.currency}.${supplyOrderModel.quantity! * int.parse(supplyOrderModel.product!.sellingPrice![0])}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(DateFormat('yyyy-MM-dd hh:mm a')
                          .format(supplyOrderModel.createdAt!)
                          .toString()),
                      SizedBox(height: 5),
                      if (supplyOrderModel.returned == true)
                        Text(
                          "Product Returned to Supplier",
                          style: TextStyle(color: Colors.red),
                        )
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

showProductModal(context, SupplyOrderModel supplyOrderModel, type) {
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.all(8.0),
                    width: double.infinity,
                    color: Colors.white,
                    child: Text('Manage ${supplyOrderModel.product!.name}')),
                ListTile(
                  title: Text("Return to supplier"),
                  leading: Icon(Icons.recycling),
                  onTap: () {
                    Get.back();
                    if (supplyOrderModel.supplier == null) {
                      showSnackBar(
                          message: "no supplier found", color: Colors.red);
                    } else {
                      showQuantityDialog(context, supplyOrderModel);
                    }
                  },
                ),
                ListTile(
                  title: Text("Delete"),
                  leading: Icon(Icons.delete, color: Colors.red),
                  onTap: () {
                    Get.back();
                    deleteDialog(context: context, onPressed: () {});
                  },
                ),
              ],
            ));
      });
}

showQuantityDialog(context, SupplyOrderModel supplyOrderModel) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.fromLTRB(10, 20, 20, 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Add Quantity to return"),
                SizedBox(height: 10),
                TextFormField(
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
                      },
                      child: Text(
                        "Save Now".toUpperCase(),
                        style: TextStyle(color: Colors.purple),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      });
}
