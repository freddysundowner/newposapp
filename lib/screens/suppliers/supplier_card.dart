import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/supplier.dart';
import 'package:pointify/screens/suppliers/supplier_info_page.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

Widget supplierCard({required SupplierModel supplierModel, required context}) {
  return Card(
      color: AppColors.mainColor,
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
                    color: Colors.white,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        majorTitle(
                            title: "Name: ${supplierModel.fullName}",
                            color: Colors.white,
                            size: 15.0),
                        SizedBox(
                          height: 10,
                        ),
                        if (supplierModel.credit! < 0)
                          minorTitle(
                              title:
                                  "Total Debt: ${Get.find<ShopController>().currentShop.value?.currency} ${supplierModel.credit}",
                              color: Colors.red),
                        if (supplierModel.credit! > 0)
                          minorTitle(
                              title:
                                  "Total Credit: ${Get.find<ShopController>().currentShop.value?.currency} ${supplierModel.credit}",
                              color: Colors.green),
                        SizedBox(
                          height: 10,
                        ),
                        minorTitle(
                            title: "Phone: ${supplierModel.phoneNumber}",
                            color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      SupplierInfoPage(
                    supplierModel: supplierModel,
                  );
                } else {
                  Get.to(() => SupplierInfoPage(
                        supplierModel: supplierModel,
                      ));
                }
              },
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: (BorderRadius.circular(10)),
                    border: Border.all(color: Colors.white, width: 1)),
                child: majorTitle(
                    title: "View Account", color: Colors.white, size: 12.0),
              ),
            )
          ],
        ),
      ));
}
