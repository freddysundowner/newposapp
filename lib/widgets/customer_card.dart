import 'package:flutter/material.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../models/customer_model.dart';
import '../screens/customers/customer_info_page.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

Widget customerWidget({required CustomerModel customerModel, required type}) {
  return Card(
      color: AppColors.mainColor,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Column(
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
                        color: Colors.white)
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Get.to(() => CustomerInfoPage(
                        id: customerModel.id,
                        user: type,
                      ));
                },
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: (BorderRadius.circular(10)),
                      border: Border.all(color: Colors.white, width: 1)),
                  child: majorTitle(
                      title: "View Profile", color: Colors.white, size: 12.0),
                ),
              ),
            )
          ],
        ),
      ));
}
