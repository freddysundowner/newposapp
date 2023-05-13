import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/shop_category.dart';
import 'package:pointify/models/shop_model.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/authentication/shop_cagories.dart';
import 'package:pointify/screens/home/shops_page.dart';
import 'package:pointify/utils/constants.dart';
import 'package:get/get.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shop_widget.dart';
import '../../widgets/smalltext.dart';

class CreateShop extends StatelessWidget {
  final page;

  CreateShop({Key? key, required this.page}) : super(key: key) {
    shopController.clearTextFields();
  }

  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            if (MediaQuery.of(context).size.width > 600) {
              Get.find<HomeController>().selectedWidget.value = ShopsPage();
            } else {
              Get.back();
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
      body: ResponsiveWidget(
          largeScreen: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shopDetails(context),
                  SizedBox(height: 10),
                  Obx(() {
                    return shopController.createShopLoad.value
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: saveButton(context),
                          );
                  }),
                ],
              ),
            ),
          ),
          smallScreen: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: shopDetails(context),
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.width > 600
              ? 0
              : kToolbarHeight * 1.5,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Obx(() {
            return shopController.createShopLoad.value
                ? const Center(child: CircularProgressIndicator())
                : saveButton(context);
          }),
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
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: majorTitle(
                title: "Create ", color: AppColors.mainColor, size: 18.0)),
      ),
    );
  }

  Widget shopDetails(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        shopWidget(
            controller: shopController.nameController, name: "Shop Name"),
        SizedBox(height: 10),
        Text(
          "Business Type",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () {
            Get.to(() => ShopCategories(
                  selectedItemsCallback: (ShopCategory s) {
                    Get.back();
                    shopController.selectedCategory.value = s;
                  },
                ));
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
                    : shopController.selectedCategory.value!.title)),
                const Icon(Icons.arrow_forward_ios_rounded)
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        shopWidget(
            controller: shopController.reqionController, name: "Location"),
        SizedBox(height: 10),
        majorTitle(title: "Currency", color: Colors.black, size: 16.0),
        SizedBox(height: 5),
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
                                    "${Constants.currenciesData.elementAt(index)}"),
                              )),
                    );
                  });
            },
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Obx(() {
                    return Text(
                        " ${shopController.currency.value == "" ? Constants.currenciesData[0] : shopController.currency}",
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12.0));
                  }),
                  Spacer(),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                majorTitle(title: "Accept", color: Colors.black, size: 13.0),
                SizedBox(width: 4),
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
        SizedBox(height: 10),
      ],
    );
  }
}
