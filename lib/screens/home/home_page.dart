import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(title: "Current Shop", color: Colors.black, size: 20.0),
            SizedBox(height: 5),
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

                    await shopController.getShopsByAdminId(adminId: authController.currentUser.value?.id);
                    showShopModalBottomSheet(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.mainColor, width: 2),
                    ),
                    child: minorTitle(
                        title: "Change Shop", color: AppColors.mainColor),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      majorTitle(
                          title: "Today's Sale",
                          color: Colors.white,
                          size: 18.0),
                      SizedBox(height: 10),
                      minorTitle(title: "Calculating...", color: Colors.white)
                    ],
                  ),
                  InkWell(
                    onTap: () {},
                    child: majorTitle(
                        title: "View More", color: Colors.white, size: 18.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            majorTitle(
                title: "Enterprise Operations",
                color: Colors.black,
                size: 20.0),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(20)),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                // physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                children: [
                  gridItems(
                      title: "Sell",
                      iconData: Icons.sell_rounded,
                      function: () {}),
                  gridItems(
                      title: "Finance",
                      iconData: Icons.request_quote_outlined,
                      function: () {}),
                  gridItems(
                      title: "Stock",
                      iconData: Icons.production_quantity_limits,
                      function: () {}),
                  gridItems(
                      title: "Suppliers",
                      iconData: Icons.people_alt,
                      function: () {}),
                  gridItems(
                      title: "Customers",
                      iconData: Icons.people_outline_outlined,
                      function: () {}),
                  gridItems(
                      title: "Usage",
                      iconData: Icons.data_usage,
                      function: () {}),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                majorTitle(
                    title: "Sales History", color: Colors.black, size: 20.0),
                InkWell(
                    onTap: () {},
                    child: minorTitle(
                        title: "See all", color: AppColors.lightDeepPurple))
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    ));
  }

  showShopModalBottomSheet(context) {
    showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      ),
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: ListView.builder(
            itemCount: shopController.AdminShops.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              ShopModel shopModel = shopController.AdminShops.elementAt(index);
              return InkWell(
                onTap: () {
                  shopController.currentShop.value = shopModel;
                  Get.back();
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: majorTitle(
                      title: "${shopModel.name}",
                      color: Colors.black,
                      size: 16.0),
                ),
              );
            }),
      ),
    );
  }

  Widget gridItems(
      {required title, required IconData iconData, required function}) {
    return InkWell(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                iconData,
                size: 40,
                color: AppColors.mainColor,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ],
      ),
      onTap: () {
        function();
      },
    );
  }
}
