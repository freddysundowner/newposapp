import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../screens/stock/transfer_history_view.dart';
import '../utils/colors.dart';

Widget transferHistoryCard(){
  return InkWell(
    onTap: (){
      Get.to(()=>TransferHistoryView());
    },
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8, right: 8,top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            "Shop1 to shop2",
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w500),
          ),
          Text(
            "Variance Transferred:2 ",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            "Transfered by: John",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            "${DateFormat("dd/MM/yyyy").format(DateTime.now())}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ),
  );
}