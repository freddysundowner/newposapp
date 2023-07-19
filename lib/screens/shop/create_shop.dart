import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/shop/shop_cagories.dart';
import 'package:pointify/screens/shop/shops_page.dart';
import 'package:pointify/utils/constants.dart';
import 'package:get/get.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../Real/schema.dart';
import '../../controllers/plan_controller.dart';
import '../../services/shop_services.dart';
import '../../data/interests.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shop_widget.dart';
import '../../widgets/smalltext.dart';

class CreateShop extends StatelessWidget {
  final page;
  bool? clearInputs = false;

  CreateShop({Key? key, required this.page, this.clearInputs})
      : super(key: key) {
    if (clearInputs!) {
      shopController.clearTextFields();
    }

    Interests();
  }

  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    Get.find<PlanController>().getPlans();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 3,
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: page == "home"
            ? null
            : IconButton(
                onPressed: () {
                  if (isSmallScreen(context)) {
                    Get.back();
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        ShopsPage();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
        title:
            majorTitle(title: "Create Shop", color: Colors.black, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(boxShadow: []),
          padding: EdgeInsets.all(page == "home" ? 30 : 10),
          margin: EdgeInsets.symmetric(horizontal: page == "home" ? 50 : 0),
          height: MediaQuery.of(context).size.height,
          child: shopDetails(context),
        ),
      ),
    );
  }

  Widget saveButton(context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        shopController.createShop(page: page, context: context);
      },
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          width: isSmallScreen(context) ? double.infinity : 300,
          decoration: BoxDecoration(
              border: Border.all(width: 3, color: AppColors.mainColor),
              borderRadius: BorderRadius.circular(40)),
          child: Center(
              child: majorTitle(
                  title: "Create ", color: AppColors.mainColor, size: 18.0)),
        ),
      ),
    );
  }

  Widget shopDetails(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        shopWidget(
            controller: shopController.nameController, name: "Shop Name"),
        const SizedBox(height: 10),
        const Text(
          "Business Type",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            if (page == "home") {
              Get.to(() => ShopCategories(
                    selectedItemsCallback: (ShopTypes s) {
                      Get.back();
                      shopController.selectedCategory.value = s;
                    },
                    page: page,
                  ));
            } else {
              if (isSmallScreen(context)) {
                Get.to(() => ShopCategories(
                      selectedItemsCallback: (ShopTypes s) {
                        Get.back();
                        shopController.selectedCategory.value = s;
                      },
                      page: page,
                    ));
              } else {
                Get.find<HomeController>().selectedWidget.value =
                    ShopCategories(
                  page: page,
                  selectedItemsCallback: (ShopTypes s) {
                    Get.find<HomeController>().selectedWidget.value =
                        CreateShop(
                      page: page,
                      clearInputs: false,
                    );

                    shopController.selectedCategory.value = s;
                  },
                );
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(shopController.selectedCategory.value == null
                    ? ""
                    : shopController.selectedCategory.value!.title!)),
                const Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        shopWidget(
            controller: shopController.reqionController, name: "Location"),
        const SizedBox(height: 10),
        majorTitle(title: "Currency", color: Colors.black, size: 16.0),
        const SizedBox(height: 5),
        Card(
          elevation: 1,
          child: InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: List.generate(
                          Constants.currenciesData.length,
                          (index) => SimpleDialogOption(
                                onPressed: () {
                                  shopController.currency.value =
                                      Constants.currenciesData.elementAt(index);

                                  Navigator.pop(context);
                                },
                                child: Text(
                                    Constants.currenciesData.elementAt(index)),
                              )),
                    );
                  });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Obx(() {
                    return Text(
                        " ${shopController.currency.value == "" ? Constants.currenciesData[0] : shopController.currency}",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12.0));
                  }),
                  const Spacer(),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                majorTitle(title: "Accept", color: Colors.black, size: 13.0),
                const SizedBox(width: 4),
                minorTitle(
                    title: "terms and conditions", color: AppColors.mainColor)
              ],
            ),
            SwitcherButton(
                onChange: (value) {
                  shopController.terms.value = value;
                },
                onColor: Colors.purple,
                offColor: Colors.grey)
          ],
        ),
        const SizedBox(height: 30),
        Obx(() {
          return shopController.createShopLoad.value
              ? const Center(child: CircularProgressIndicator())
              : saveButton(context);
        })
      ],
    );
  }
}
