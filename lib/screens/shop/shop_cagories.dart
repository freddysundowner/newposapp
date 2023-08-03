import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/screens/shop/shop_details.dart';
import 'package:pointify/utils/colors.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/home_controller.dart';

//ignore: must_be_immutable
class ShopCategories extends StatelessWidget {
  final String page;
  final Shop? shopModel;
  final Function? selectedItemsCallback;

  ShopCategories(
      {super.key,
      this.selectedItemsCallback,
      required this.page,
      this.shopModel}) {
    shopController.getCategories();
  }

  final AuthController authController = Get.find<AuthController>();
  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    print(page);
    return Scaffold(
      resizeToAvoidBottomInset: false, // set
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.clear, color: Colors.black),
          onPressed: () {
            if (page == "home") {
              Get.back();
            } else if (isSmallScreen(context)) {
              Get.back();
            } else {
              if (page == "details") {
                Get.find<HomeController>().selectedWidget.value =
                    ShopDetails(shopModel: shopModel!);
              } else {
                Get.find<HomeController>().selectedWidget.value = CreateShop(
                  page: page,
                  clearInputs: false,
                );
              }
            }

            // Navigator.of(context).pop();
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text(
          "Choose Shop Category",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          return shopController.loadingcateries.isFalse
              ? ListView(
                  children: listMyWidgets(),
                )
              : SizedBox(
                  height: 20,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  )));
        }),
      ),
    );
  }

  List<Widget> listMyWidgets() {
    List<Widget> list = [];

    for (var item in shopController.categories) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              selectedItemsCallback!(item);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Text(
                    item.title!,
                    style: TextStyle(fontSize: 15, color: AppColors.mainColor),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.lightDeepPurple,
                )
              ],
            ),
          ),
          const Divider()
        ],
      ));
    }
    return list;
  }
}
