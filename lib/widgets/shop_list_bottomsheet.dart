import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/shop_model.dart';
import 'package:pointify/widgets/bigtext.dart';

showShopModalBottomSheet(context) {
  ShopController shopController = Get.find<ShopController>();
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), topLeft: Radius.circular(15)),
    ),
    builder: (context) => SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            itemCount: shopController.allShops.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ShopModel shopBody = shopController.allShops.elementAt(index);
              return InkWell(
                onTap: () {
                  Get.back();
                  shopController.setDefaulShop(shopBody);
                  Get.find<AuthController>()
                      .init(Get.find<AuthController>().usertype.value);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shop),
                              majorTitle(
                                  title: "${shopBody.name}",
                                  color: Colors.black,
                                  size: 16.0),
                            ],
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                      Divider()
                    ],
                  ),
                ),
              );
            }),
      ),
    ),
  );
}
