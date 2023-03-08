import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/shop/create_shop.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/shop_card.dart';
import '../../widgets/smalltext.dart';

class ShopsPage extends StatelessWidget {
  ShopsPage({Key? key}) : super(key: key) {
    shopController.getShopsByAdminId(
        adminId: authController.currentUser.value?.id);
  }

  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: ResponsiveWidget(
        largeScreen: Obx(() => Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: searchWidget(),
                          flex: 3,
                        ),
                        Spacer(),
                        createShopContainer(context),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  shopController.gettingShopsLoad.value
                      ? loadingWidget(context)
                      : shopController.AdminShops.length == 0
                          ? noItemsFound(context, true)
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, right: 20),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1.3 /
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10),
                                  shrinkWrap: true,
                                  itemCount: shopController.AdminShops.length,
                                  itemBuilder: (context, index) {
                                    ShopModel shopModel =
                                        shopController.AdminShops.elementAt(
                                            index);
                                    return shopCard(
                                        shopModel: shopModel, page: "shop");
                                  }),
                            )
                ],
              ),
            )),
        smallScreen: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: createShopContainer(context),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: searchWidget(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Obx(() {
              return shopController.gettingShopsLoad.value
                  ? loadingWidget(context)
                  : shopController.AdminShops.length == 0
                      ? noItemsFound(context, true)
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: shopController.AdminShops.length,
                          itemBuilder: (context, index) {
                            ShopModel shopModel =
                                shopController.AdminShops.elementAt(index);
                            return shopCard(shopModel: shopModel, page: "shop");
                          });
            })
          ],
        ),
      ),
    ));
  }

  Widget createShopContainer(context) {
    HomeController homeController = Get.find<HomeController>();
    return InkWell(
      onTap: () {
        Get.to(CreateShop(
          page: "shop",
        ));
      },
      child: Container(
        padding: ResponsiveWidget.isSmallScreen(context)
            ? EdgeInsets.symmetric(horizontal: 10, vertical: 2)
            : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: ResponsiveWidget.isSmallScreen(context)
              ? Colors.white
              : AppColors.mainColor,
          borderRadius: ResponsiveWidget.isSmallScreen(context)
              ? BorderRadius.circular(10)
              : BorderRadius.circular(8),
          border: Border.all(color: AppColors.mainColor, width: 2),
        ),
        child: minorTitle(
            title: "+ Add Shop",
            color: ResponsiveWidget.isSmallScreen(context)
                ? AppColors.mainColor
                : Colors.white),
      ),
    );
  }

  Widget searchWidget() {
    return TextFormField(
      controller: shopController.searchController,
      onChanged: (value) {
        shopController.getShopsByAdminId(
            adminId: authController.currentUser.value?.id, name: value);
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          suffixIcon: IconButton(
            onPressed: () {
              if (shopController.searchController.text == "") {
              } else {
                shopController.getShopsByAdminId(
                    adminId: authController.currentUser.value?.id,
                    name: shopController.searchController.text);
              }
            },
            icon: Icon(Icons.search),
          ),
          hintText: "Search Shop",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget loadingWidget(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
