import 'package:flutter/material.dart';
import 'package:pointify/models/stockTransferHistoryModel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../screens/stock/transfer_history_view.dart';
import '../utils/colors.dart';

Widget transferHistoryCard(
    {required StockTransferHistory stockTransferHistory}) {
  return InkWell(
    onTap: () {
      Get.to(() => TransferHistoryView(id: stockTransferHistory.id!));
    },
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8, right: 8, top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.mainColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            "${stockTransferHistory.from!.name} to ${stockTransferHistory.to!.name}"
                .capitalize!,
            style: TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          Text(
            "Variance Transferred:${stockTransferHistory.product!.length}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            "${DateFormat("dd/MM/yyyy").format(stockTransferHistory.createdAt!)}",
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
