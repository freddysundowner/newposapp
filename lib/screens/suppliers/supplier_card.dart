import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/suppliers/supplier_info_page.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

Widget supplierCard(
    {required Supplier supplierModel, Function? function, String type = ""}) {
  return Card(
      child: Container(
    padding: EdgeInsets.all(10),
    child: Row(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title: "Name: ${supplierModel.fullName}",
                        color: Colors.black,
                        size: 15.0),
                    SizedBox(
                      height: 10,
                    ),
                    minorTitle(
                      title: "Phone: ${supplierModel.phoneNumber}",
                      color: Colors.black,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        type == "purchases"
            ? InkWell(
                onTap: () {
                  Get.back();
                  Get.find<PurchaseController>().invoice.value!.supplier =
                      supplierModel;
                  Get.find<PurchaseController>().invoice.refresh();
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: (BorderRadius.circular(10)),
                      border: Border.all(color: AppColors.mainColor, width: 1)),
                  child: majorTitle(
                      title: "Select", color: AppColors.mainColor, size: 12.0),
                ),
              )
            : Column(
                children: [
                  if (supplierModel.balance != null &&
                      supplierModel.balance! > 0)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: minorTitle(
                          title: "Credit ${htmlPrice(supplierModel.balance)}",
                          color: Colors.red),
                    ),
                  if (supplierModel.balance != null &&
                      supplierModel.balance! < 0)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      child: minorTitle(
                          title: "Unpaid ${htmlPrice(supplierModel.balance)}",
                          color: Colors.red),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () => function!(supplierModel),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: (BorderRadius.circular(5)),
                          border:
                              Border.all(color: AppColors.mainColor, width: 1)),
                      child: majorTitle(
                          title: "View Account",
                          color: AppColors.mainColor,
                          size: 12.0),
                    ),
                  ),
                ],
              )
      ],
    ),
  ));
}
