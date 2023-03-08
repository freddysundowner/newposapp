import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:get/get.dart';

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
                onTap: () {
                  // deleteAccountDialog(context);
                  print(e["page"]);
                },
                icon: e["icon"],
                title: e["page"],
                context: context))
            .toList(),
      ),
    );
  }

  Widget sideMenuItems(
      {required onTap,
      required IconData icon,
      required title,
      required context}) {
    return Obx(() => InkWell(
          onTap: () {
            print(title);
            if (title == "Log Out") {
              deleteDialog(
                  context: context,
                  onPressed: () {
                    Get.find<AuthController>().deleteAdmin(
                        context: context,
                        id: Get.find<AuthController>().currentUser.value?.id);
                  });
            } else {
              homeController.activeItem.value = title;
              onTap();
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
