import 'package:flutter/material.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/schema.dart';
import '../screens/attendant/attendant_details.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

Widget attendantCard({required UserModel userModel, Function? function}) {
  return InkWell(
    onTap: () {
      if (function != null) {
        function(userModel);
      } else {
        Get.to(() => AttendantDetails(userModel: userModel));
      }
    },
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.person,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  majorTitle(
                      title: "Name: ${userModel.username}",
                      color: Colors.black,
                      size: 16.0),
                  const SizedBox(width: 10),
                  minorTitle(
                      title: "Id: ${userModel.UNID}", color: Colors.black)
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              )
            ],
          ),
          const Divider()
        ],
      ),
    ),
  );
}
