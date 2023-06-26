import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/attendant/attendants_page.dart';
import 'package:pointify/screens/shop/shops_page.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/logout.dart';
import 'package:get/get.dart';

import '../screens/home/home_page.dart';
import '../screens/home/profile_page.dart';
import '../utils/constants.dart';
import 'delete_dialog.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);
  HomeController homeController = Get.find<HomeController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      color: const Color(0xff3a3055),
      child: ListView(
        children: sidePages
            .map((e) => sideMenuItems(
                icon: e["icon"], title: e["page"], context: context))
            .toList(),
      ),
    );
  }

  Widget sideMenuItems(
      {required IconData icon, required title, required context}) {
    return Obx(() => InkWell(
          onTap: () {
            homeController.activeItem.value = title;
            if (title == "Home") {
              homeController.selectedWidget.value = HomePage();
            } else if (title == "Shops") {
              shopController.getShops();
              homeController.selectedWidget.value = ShopsPage();
            } else if (title == "Attendants") {
              homeController.selectedWidget.value = AttendantsPage();
            } else if (title == "Profile") {
              homeController.selectedWidget.value = ProfilePage();
            } else if (title == "Log Out") {
              logoutAccountDialog(context);
            }
          },
          onHover: (value) {
            if (value) {
              homeController.hoveredItem.value = title;
            } else {
              homeController.hoveredItem.value = "";
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: homeController.activeItem.value == title
                  ? const Color(0xffbe741f)
                  : const Color(0xff3a3055),
              borderRadius: BorderRadius.circular(10)
            ),
            
            padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 3).copyWith(left: 6),
            margin: const EdgeInsets.symmetric(horizontal: 3).copyWith(top: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "$title",
                      style: const TextStyle(
                          color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                // const Divider(color: Colors.white, height: 0.5),
              ],
            ),
          ),
        ));
  }
}
