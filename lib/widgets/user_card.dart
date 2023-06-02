import 'package:flutter/material.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/Models/schema.dart';
import '../screens/attendant/attendant_details.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

Widget attendantCard({required UserModel userModel}) {
  return Container(
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.all(15),
    width: double.infinity,
    decoration: BoxDecoration(
        color: AppColors.mainColor, borderRadius: BorderRadius.circular(20)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.person,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                majorTitle(
                    title: "Name: ${userModel.fullnames}",
                    color: Colors.white,
                    size: 16.0),
                SizedBox(width: 10),
                // minorTitle(
                //     title: "Id: ${userModel.attendid}", color: Colors.white)
              ],
            ),
          ],
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () {
            Get.to(() => UserModelDetails(userModel: userModel));
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  borderRadius: BorderRadius.circular(20)),
              child: majorTitle(
                  title: "View Profile", color: Colors.white, size: 14.0),
            ),
          ),
        )
      ],
    ),
  );
}
