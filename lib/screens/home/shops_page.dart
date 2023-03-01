import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/screens/shop/create_shop.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shop_card.dart';
import '../../widgets/smalltext.dart';

class ShopsPage extends StatelessWidget {
  ShopsPage({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    shopController.getShopsByAdminId(
        adminId: authController.currentUser.value?.id);

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Get.to(CreateShop(page: "shop",));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.mainColor, width: 2),
                  ),
                  child: minorTitle(
                      title: "+ Add Shop", color: AppColors.mainColor),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: shopController.searchController,
                    onChanged: (value) {
                      shopController.getShopsByAdminId(adminId: authController.currentUser.value?.id,name: value);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (shopController.searchController.text=="") {

                            }  else{
                              shopController.getShopsByAdminId(
                                  adminId: authController.currentUser.value?.id,
                                  name: shopController.searchController.text);
                            }

                          },
                          icon: Icon(Icons.search),
                        ),
                        hintText: "Search Shop",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Obx(() {
            return shopController.gettingShopsLoad.value
                ? Center(child: CircularProgressIndicator())
                : shopController.AdminShops.length == 0
                    ? Center(
                        child: majorTitle(
                            title: "You do not have shop yet",
                            color: Colors.black,
                            size: 16.0),
                      )
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
    ));
  }
}
