import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../models/customer_model.dart';
import '../screens/customers/customer_info_page.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

Widget customerWidget(
    {required CustomerModel customerModel, required context}) {
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
                            title: "Name: ${customerModel.fullName}",
                            color: Colors.white,
                            size: 15.0),
                        SizedBox(
                          height: 10,
                        ),
                        minorTitle(
                            title: "Phone: ${customerModel.phoneNumber}",
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
