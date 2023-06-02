import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/utils/colors.dart';

import '../../controllers/AuthController.dart';

//ignore: must_be_immutable
class ShopCategories extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Function? selectedItemsCallback;
  final showbackarrow;
  ShopCategories(
      {this.title,
      this.subtitle,
      this.selectedItemsCallback,
      this.showbackarrow}) {
    shopController.getCategories();
  }

  final AuthController authController = Get.find<AuthController>();
  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.clear, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Choose Shop Category",
          style: TextStyle(
              color: AppColors.mainColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold),
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
                  height: 0.2.sh,
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
