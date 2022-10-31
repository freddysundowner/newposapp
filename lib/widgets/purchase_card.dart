import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_order_item_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import 'delete_dialog.dart';

Widget purchaseCard({required context, required SaleOrderItemModel saleOrderItemModel}) {
  ShopController shopController=Get.find<ShopController>();
  return InkWell(
    child: Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      "${saleOrderItemModel.product!.name}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Qty ${saleOrderItemModel.itemCount} @ ${shopController.currentShop.value?.currency}.${saleOrderItemModel.price}  =  ${shopController.currentShop.value?.currency}.${saleOrderItemModel.total}",
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          DateFormat().format(saleOrderItemModel.createdAt!),
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "By-${saleOrderItemModel.attendantid?.fullnames}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )),
      ),
    ),
  );
}

showBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 150,
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.7),
                        child: Text('Manage Bank')),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // editingDialog(
                      //   context: context,
                      //   onPressed: () {},
                      // );
                    },
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Edit'))
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          deleteDialog(context: context, onPressed: () {});
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Delete'))
                          ],
                        ),
                      ),
                    ),
                  ],
                )));
      });
}
