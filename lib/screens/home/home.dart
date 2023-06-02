import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/bigtext.dart';
import 'package:pointify/widgets/side_menu.dart';
import 'package:get/get.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/realm_controller.dart';
import '../../controllers/home_controller.dart';
import '../../utils/colors.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController homeControler = Get.put(HomeController());

  SalesController salesController = Get.put(SalesController());

  ShopController shopController = Get.put(ShopController());

  UserController userController = Get.find<UserController>();

  AuthController authController = Get.find<AuthController>();

  final RealmController realmService = Get.put(RealmController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userController.getUser();
  }

  // StreamController streamController = Get.find<StreamController>();
  @override
  Widget build(BuildContext context) {
    userController.getAttendantRoles();
    return ResponsiveWidget(
        largeScreen: Obx(() => Scaffold(
              backgroundColor: Colors.white,
              appBar: top_appbar(),
              body: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SideMenu(),
                  ),
                  Expanded(flex: 4, child: homeControler.selectedWidget.value!)
                ],
              ),
            )),
        smallScreen: Helper(
          widget: Obx(() {
            return homeControler.pages[homeControler.selectedIndex.value];
          }),
          appBar: top_appbar(),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
                color: AppColors.lightDeepPurple,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      final DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      final String formatted = formatter.format(now);
                      salesController.getSalesByDate(formatted);
                      homeControler.selectedIndex.value = 0;
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Icon(
                            Icons.home,
                            color: homeControler.selectedIndex.value == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        Text("Home")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      homeControler.selectedIndex.value = 1;
                      shopController.getShops();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Icon(Icons.shop,
                              color: homeControler.selectedIndex.value == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Text("Shops")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      homeControler.selectedIndex.value = 2;

                      userController.getAttendantsByShopId(
                          shopId: shopController.currentShop.value?.id);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Icon(Icons.people,
                              color: homeControler.selectedIndex.value == 2
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Text("Attendants")
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      homeControler.selectedIndex.value = 3;
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => Icon(Icons.people,
                              color: homeControler.selectedIndex.value == 3
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        Text("Profile")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  AppBar top_appbar() {
    return AppBar(
      titleSpacing: 0.0,
      leading: Icon(
        Icons.electric_bolt,
        color: AppColors.mainColor,
      ),
      title: majorTitle(title: "Store Admin", color: Colors.black, size: 16.0),
      elevation: 0.2,
      backgroundColor: Colors.white,
    );
  }
}
