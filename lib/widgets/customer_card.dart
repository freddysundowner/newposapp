import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/schema.dart';
import '../screens/customers/customer_info_page.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

Widget customerWidget(
    {required CustomerModel customerModel, required context, String? type}) {
  return InkWell(
    onTap: () {
      if (MediaQuery.of(context).size.width > 600) {
        Get.find<HomeController>().selectedWidget.value = CustomerInfoPage(
          customerModel: customerModel,
        );
      } else {
        Get.to(() => CustomerInfoPage(
              customerModel: customerModel,
            ));
      }
    },
    child: Card(
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
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      majorTitle(
                          title: "Name: ${customerModel.fullName}",
                          color: Colors.black,
                          size: 15.0),
                      SizedBox(
                        height: 10,
                      ),
                      minorTitle(
                          title: "Phone: ${customerModel.phoneNumber}",
                          color: Colors.black),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          type == "sale"
              ? InkWell(
                  onTap: () {
                    Get.back();
                    Get.find<SalesController>().receipt.value!.customerId =
                        customerModel;
                    Get.find<SalesController>().receipt.refresh();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: (BorderRadius.circular(10)),
                        border:
                            Border.all(color: AppColors.mainColor, width: 1)),
                    child: majorTitle(
                        title: "Select",
                        color: AppColors.mainColor,
                        size: 12.0),
                  ),
                )
              : Column(
                  children: [
                    InkWell(
                      onTap: () {
                        if (MediaQuery.of(context).size.width > 600) {
                          Get.find<HomeController>().selectedWidget.value =
                              CustomerInfoPage(
                            customerModel: customerModel,
                          );
                        } else {
                          Get.to(() => CustomerInfoPage(
                                customerModel: customerModel,
                              ));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: (BorderRadius.circular(10)),
                            border: Border.all(
                                color: AppColors.mainColor, width: 1)),
                        child: majorTitle(
                            title: "View Account",
                            color: AppColors.mainColor,
                            size: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (customerModel.walletBalance != null &&
                        customerModel.walletBalance! < 0)
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(5)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        child: minorTitle(
                            title:
                                "Unpaid ${htmlPrice(customerModel.walletBalance!.abs())}",
                            color: Colors.red),
                      )
                  ],
                )
        ],
      ),
    )),
  );
}
