import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/screens/home/attendants_page.dart';
import 'package:flutterpos/screens/home/shops_page.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/logout.dart';
import 'package:get/get.dart';

import '../screens/home/home_page.dart';
import '../screens/home/profile_page.dart';
import '../utils/constants.dart';
import 'delete_dialog.dart';

class SideMenu extends StatelessWidget {
  SideMenu({Key? key}) : super(key: key);
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20),
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
            padding: EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: homeController.activeItem.value == title
                      ? AppColors.mainColor
                      : Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${title}",
                  style: TextStyle(
                      color: homeController.activeItem.value == title
                          ? AppColors.mainColor
                          : Colors.grey),
                )
              ],
            ),
          ),
        ));
  }
}
