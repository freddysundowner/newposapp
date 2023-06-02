import 'package:flutter/material.dart';
import 'package:pointify/screens/shop/shop_details.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';

import '../Real/Models/schema.dart';
import '../screens/stock/products_selection.dart';
import '../utils/colors.dart';
import 'bigtext.dart';

Widget shopCard({required Shop shopModel, required page, required context}) {
  return InkWell(
    onTap: () {
      if (page == "shop") {
        Get.to(() => ShopDetails(shopModel: shopModel));
      } else {
        Get.to(() => ProductSelections(toShop: shopModel));
      }
    },
    child: Container(
      margin: EdgeInsets.fromLTRB(3, 10, 3, 0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.mainColor, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shopping_basket,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              majorTitle(title: shopModel.name, color: Colors.white, size: 14.0)
            ],
          ),
          SizedBox(height: 10),
          minorTitle(
              title: "Location- ${shopModel.location}", color: Colors.white),
          SizedBox(height: 10),
          // minorTitle(title: "Type- ${shopModel.category}", color: Colors.white)
        ],
      ),
    ),
  );
}
