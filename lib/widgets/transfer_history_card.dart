import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/shop_controller.dart';

import '../Real/Models/schema.dart';
import '../screens/stock/transfer_history_view.dart';
import '../utils/colors.dart';

Widget transferHistoryCard(
    {required StockTransferHistory stockTransferHistory}) {
  ShopController shopController = Get.find<ShopController>();
  return InkWell(
    onTap: () {
      Get.to(() => TransferHistoryView(id: stockTransferHistory.id!));
    },
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 8, right: 8, top: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stockTransferHistory.from?.id ==
                  shopController.currentShop.value?.id)
                Text(
                  "To ${stockTransferHistory.to!.name}".capitalize!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              if (stockTransferHistory.from?.id !=
                  shopController.currentShop.value?.id)
                Text(
                  "From ${stockTransferHistory.from!.name}".capitalize!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              Text(
                "Products ${stockTransferHistory.from?.id == shopController.currentShop.value?.id ? "Transferred" : "Received"}:${stockTransferHistory.product.length}",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              if (stockTransferHistory.createdAt != null)
                Text(
                  DateFormat("dd/MM/yyyy")
                      .format(stockTransferHistory.createdAt!),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              Divider()
            ],
          ),
          Spacer(),
          Text("By ~ ${stockTransferHistory.attendant?.fullnames}")
        ],
      ),
    ),
  );
}
