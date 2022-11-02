import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/widgets/shop_card.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class StockTransfer extends StatelessWidget {
  StockTransfer({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    shopController.getShopsByAdminId(
        adminId: authController.currentUser.value?.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.mainColor, width: 2)),
                child: majorTitle(
                    title: "Transfer History",
                    color: AppColors.mainColor,
                    size: 12.0),
              ),
            ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(
                title: "Stock Transfer", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${shopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: majorTitle(
                    title: "Select Shop to transfer to",
                    color: Colors.black,
                    size: 16.0),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: shopController.searchController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                            ),
                            hintText: "Search Shop to transfer to",
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
                    ? Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator())
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
                              return shopCard(
                                  shopModel: shopModel, page: "stockTransfer");
                            });
              })
            ],
          ),
        ),
      ),
    );
  }
}