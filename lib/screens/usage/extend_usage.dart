import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/shop_list_bottomsheet.dart';
import 'package:pointify/widgets/smalltext.dart';

import '../../Real/schema.dart';
import '../../services/shop_services.dart';
import '../../utils/themer.dart';
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
              () => ListView.builder(
                  itemCount: planController.plans.length,
                  itemBuilder: (BuildContext c, int i) {
                    Packages plan = planController.plans[i];
                    return _usageCard(plan);
                  }),
            ),
          )
        ],
      ),
    );
  }

  _usageCard(Packages plan) {
    authController.phoneController.text =
        Get.find<UserController>().user.value!.phonenumber ?? "";
    return Obx(
      () => InkWell(
        onTap: (shopController.currentShop.value!.package != null &&
                    plan.time! <
                        shopController.currentShop.value!.package!.time!) ||
                shopController.currentShop.value == null ||
                (shopController.currentShop.value!.package != null &&
                    plan.id == shopController.currentShop.value!.package!.id)
            ? null
            : () {
                showModalBottomSheet(
                    context: Get.context!,
                    builder: (context) => Container(
                          height:
                              MediaQuery.of(context).copyWith().size.height *
                                  0.50,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Pay to extend ${shopController.currentShop.value!.name} usage",
                                  style: TextStyle(fontSize: 21),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Package details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Amount : ${htmlPrice(plan.price)}",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Package : ${plan.time} days",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  RadioListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/mpesalogo.png",
                                          width: 50,
                                        ),
                                        Text(""),
                                      ],
                                    ),
                                    value: "mpesa",
                                    groupValue: "mpesa",
                                    onChanged: (value) {},
                                  ),
                                  TextFormField(
                                    controller: authController.phoneController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter mpesa number';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: ThemeHelper()
                                        .textInputDecorationDesktop(
                                            'Mpesa Phone Number',
                                            'Enter mpesa number'),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        ShopService().updateItem(
                                            shopController.currentShop.value!,
                                            package: plan);
                                        shopController
                                            .currentShop.value!.package = plan;
                                        shopController.checkSubscription();
                                        shopController.currentShop.refresh();
                                        Get.back();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          border: Border.all(
                                              color: Colors.amber, width: 2),
                                        ),
                                        child: minorTitle(
                                            title: "Pay now",
                                            color: AppColors.mainColor),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ));
              },
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
            color: shopController.currentShop.value!.package != null &&
                    plan.time! <
                        shopController.currentShop.value!.package!.time!
                ? Colors.grey
                : shopController.currentShop.value!.package != null &&
                        plan.id == shopController.currentShop.value!.package!.id
                    ? Colors.green
                    : Colors.transparent,
            border: const Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  majorTitle(
                      title: "${plan.title}", color: Colors.black, size: 16.0),
                  Text(
                      "@ ${shopController.currentShop.value?.currency} ${plan.price}"),
                  Text(plan.description!),
                  Row(
                    children: [
                      Text("${plan.time} days"),
                      const SizedBox(
                        width: 10,
                      ),
                      if (shopController.currentShop.value!.package != null &&
                          plan.id ==
                              shopController.currentShop.value!.package!.id)
                        Text(
                          "${shopController.checkDaysRemaining()} days remaining",
                          style: const TextStyle(color: Colors.red),
                        )
                    ],
                  ),
                ],
              ),
              Spacer(),
              if (shopController.currentShop.value!.package == null ||
                  plan.time! > shopController.currentShop.value!.package!.time!)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: shopController.currentShop.value!.package != null &&
                            plan.id ==
                                shopController.currentShop.value!.package!.id
                        ? Colors.red
                        : Colors.amber,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: minorTitle(
                      title: shopController.currentShop.value!.package !=
                                  null &&
                              plan.id ==
                                  shopController.currentShop.value!.package!.id
                          ? "Active"
                          : "Subscribe",
                      color: shopController.currentShop.value!.package !=
                                  null &&
                              plan.id ==
                                  shopController.currentShop.value!.package!.id
                          ? Colors.white
                          : AppColors.mainColor),
                )
            ],
          ),
        ),
      ),
    );
  }
}
