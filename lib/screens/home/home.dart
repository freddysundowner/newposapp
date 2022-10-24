
import 'package:flutter/material.dart';
import 'package:flutterpos/widgets/bigtext.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../controllers/home_controller.dart';
import '../../utils/colors.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  HomeController homeControler = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: Icon(
          Icons.electric_bolt,
          color: AppColors.mainColor,
        ),
        title:
        majorTitle(title: "Store Admin", color: Colors.black, size: 16.0),
        elevation: 0.2,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        return homeControler.pages[homeControler.selectedIndex.value];
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Center(
          child: Icon(Icons.message),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: AppColors.lightDeepPurple,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            activeColor: Colors.white,
            color: Colors.white,
            selectedIndex: homeControler.selectedIndex.value,
            tabBackgroundColor: AppColors.mainColor,
            gap: 8,
            onTabChange: (value) {
              homeControler.selectedIndex.value = value;
              print(homeControler.selectedIndex.value);
            },
            padding: EdgeInsets.all(16),
            backgroundColor: Colors.transparent,
            tabs: [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.shop,
                text: "Shops",
              ),
              GButton(
                icon: Icons.people,
                text: "Attendants",
              ),
              GButton(
                icon: Icons.person,
                text: "Profile",
              )
            ],
          ),
        ),
      ),
    );
  }
}
