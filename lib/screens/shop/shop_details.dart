import 'package:flutter/material.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/shop/shop_cagories.dart';
import 'package:pointify/screens/shop/shops_page.dart';
import 'package:pointify/utils/constants.dart';
import 'package:pointify/widgets/shop_delete_dialog.dart';
import 'package:get/get.dart';

import '../../data/interests.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shop_widget.dart';

class ShopDetails extends StatelessWidget {
  final Shop shopModel;

  ShopDetails({Key? key, required this.shopModel}) : super(key: key) {
    shopController.initializeControllers(shopModel: shopModel);
  }

  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Interests();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          onPressed: () {
            if (isSmallScreen(context)) {
              Get.back();
            } else {
              Get.find<HomeController>().selectedWidget.value = ShopsPage();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          if (!isSmallScreen(context))
            InkWell(
              onTap: () {
                shopController.updateShop(shop: shopModel);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10)
                    .copyWith(right: 10),
                height: kTextTabBarHeight * 0.5,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Update Shop",
                  style: TextStyle(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            )
        ],
        title: majorTitle(
            title: "${shopModel.name}", color: Colors.black, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
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
                  if (isSmallScreen(context)) {
                    Get.to(() => ShopCategories(
                          shopModel: shopModel,
                          page: "details",
                          selectedItemsCallback: (ShopTypes s) async {
                            Get.back();
                            shopController.selectedCategory.value = s;
                            shopController.selectedCategory.refresh();
                            // await shopController.updateShop(shop: shopModel);
                          },
                        ));
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        ShopCategories(
                      shopModel: shopModel,
                      page: "details",
                      selectedItemsCallback: (ShopTypes s) async {
                        Get.find<HomeController>().selectedWidget.value =
                            ShopDetails(shopModel: shopModel);
                        shopController.selectedCategory.value = s;
                        shopController.selectedCategory.refresh();
                        // await shopController.updateShop(shop: shopModel);
                      },
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ), // Set border width
                    borderRadius: const BorderRadius.all(Radius.circular(
                        10.0)), // Set rounded Make rounded corner of border
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(shopController.selectedCategory.value == null
                            ? ""
                            : shopController.selectedCategory.value!.title!),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 20,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              shopWidget(
                  controller: shopController.reqionController,
                  name: "Location"),
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
                                            Constants.currenciesData
                                                .elementAt(index);

                                        Navigator.pop(context);
                                      },
                                      child: Text(Constants.currenciesData
                                          .elementAt(index)),
                                    )),
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(shopController.currency.value,
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
              Card(
                elevation: 1,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          deleteShopDialog(context, () {
                            shopController.deleteShop(
                                shop: shopModel, context: context);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delete This Shop",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text("Erase All shop Data.",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          height: isSmallScreen(context) ? kToolbarHeight * 1.5 : 0.0,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Obx(() {
            return shopController.updateShopLoad.value ||
                    shopController.deleteShopLoad.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      shopController.updateShop(shop: shopModel);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: majorTitle(
                              title: "Update Shop",
                              color: AppColors.mainColor,
                              size: 18.0)),
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
