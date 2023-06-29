import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/profile_page.dart';
import 'package:get/get.dart';
import 'package:pointify/services/users.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shopWidget.dart';

class ProfileUpdate extends StatelessWidget {
  ProfileUpdate({Key? key}) : super(key: key) {
    authController.nameController.text =
        userController.user.value!.username ?? "";
    authController.emailController.text =
        authController.app.value!.currentUser!.profile.email ?? "";
    authController.phoneController.text =
        userController.user.value!.phonenumber ?? "";
  }
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
            elevation: 0.3,
            title: majorTitle(
                title: "Edit Profile", color: Colors.black, size: 16.0),
            leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      ProfilePage();
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          body: Container(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 400,
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 0.0), //(x,y)
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    profileInputWidget(
                        controller: authController.nameController,
                        name: "Name"),
                    const SizedBox(height: 10),
                    profileInputWidget(
                        controller: authController.emailController,
                        name: "Email"),
                    const SizedBox(height: 10),
                    profileInputWidget(
                      controller: authController.phoneController,
                      name: "Phone",
                    ),
                    const SizedBox(height: 30),
                    updateButton(context: context)
                  ],
                ),
              ),
            ),
          ),
        ),
        smallScreen: Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            backgroundColor: Colors.white,
            centerTitle: false,
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
            title: majorTitle(
                title: "Edit Profile", color: Colors.black, size: 16.0),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  profileInputWidget(
                      controller: authController.nameController, name: "Name"),
                  // SizedBox(height: 10),
                  // profileInputWidget(
                  //     controller: authController.emailController,
                  //     name: "Email"),
                  SizedBox(height: 10),
                  profileInputWidget(
                      controller: authController.phoneController,
                      name: "Phone"),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                height: kToolbarHeight * 1.5,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)),
                child: updateButton(context: context)),
          ),
        ));
  }

  updateButton({required context}) {
    return Obx(() {
      return authController.updateAdminLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Users().updateAdmin(userController.user.value!,
                    username: authController.nameController.text,
                    email: authController.emailController.text,
                    phonenumber: authController.phoneController.text);
                userController.user.refresh();
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                    child: majorTitle(
                        title: "Update Profile",
                        color: AppColors.mainColor,
                        size: 18.0)),
              ),
            );
    });
  }
}
