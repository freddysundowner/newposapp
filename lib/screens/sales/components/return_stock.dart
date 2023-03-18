import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';

 returnStockDialog({required context, required id, required saleId}){
   SalesController salesController=Get.find<SalesController>();
  return   showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Return Product"),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".toUpperCase(),
                  style: TextStyle(
                      color: AppColors
                          .mainColor),
                )),
            TextButton(
                onPressed: () {
                  Get.back();
                  salesController.returnSale(id,saleId,context);
                },
                child: Text(
                  "Okay".toUpperCase(),
                  style: TextStyle(
                      color: AppColors
                          .mainColor),
                ))
          ],
        );
      });
}