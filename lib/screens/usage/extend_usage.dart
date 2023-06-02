import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/shop_list_bottomsheet.dart';
import 'package:pointify/widgets/smalltext.dart';

import '../../Real/Models/schema.dart';
import '../../widgets/bigtext.dart';

class ExtendUsage extends StatelessWidget {
  ExtendUsage({Key? key}) : super(key: key) {
    planController.getPlans();
  }

  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  PlanController planController = Get.find<PlanController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Extend usage"),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 50),
                majorTitle(
                    title: "Current Shop", color: Colors.black, size: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return minorTitle(
                          title: shopController.currentShop.value == null
                              ? ""
                              : shopController.currentShop.value!.name,
                          color: AppColors.mainColor);
                    }),
                    InkWell(
                      onTap: () async {
                        await shopController.getShops();
                        showShopModalBottomSheet(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: AppColors.mainColor, width: 2),
                        ),
                        child: minorTitle(
                            title: "Change Shop", color: AppColors.mainColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                    itemCount: planController.plans.length,
                    itemBuilder: (BuildContext c, int i) {
                      Plan plan = planController.plans[i];
                      return _usageCard(plan);
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }

  _usageCard(Plan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          majorTitle(title: "${plan.title}", color: Colors.black, size: 16.0),
          Text("@ ${shopController.currentShop.value?.currency} ${plan.price}"),
          Text(plan.description),
          Text("${plan.time} days")
        ],
      ),
    );
  }
}
