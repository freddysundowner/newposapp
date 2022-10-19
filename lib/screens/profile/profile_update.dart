import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shopWidget.dart';

class ProfileUpdate extends StatelessWidget {
  ProfileUpdate({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    authController.assignDataToTextFields();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
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
        title:
            majorTitle(title: "Edit Profile", color: Colors.black, size: 16.0),
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
              SizedBox(height: 10),
              profileInputWidget(
                  controller: authController.emailController, name: "Email"),
              SizedBox(height: 10),
              profileInputWidget(
                  controller: authController.phoneController, name: "Phone"),
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
            decoration:
                BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
            child: Obx(() {
              return authController.updateAdminLoad.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        authController.updateAdmin();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 3, color: AppColors.mainColor),
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                            child: majorTitle(
                                title: "Update Profile",
                                color: AppColors.mainColor,
                                size: 18.0)),
                      ),
                    );
            })),
      ),
    );
  }
}
