import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/snackBars.dart';
import '../profile/profile_update.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              majorTitle(
                  title: "User Details", color: Colors.black, size: 18.0),
              SizedBox(height: 10),
              Card(
                  elevation: 3,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return profileItems(
                              title: "Email",
                              subtitle: authController.currentUser.value?.email,
                              icon: Icons.email);
                        }),
                        SizedBox(height: 15),
                        Obx(() {
                          return profileItems(
                              title: "Username",
                              subtitle: authController.currentUser.value?.name,
                              icon: Icons.person);
                        }),
                        SizedBox(height: 15),
                        Obx(() {
                          return profileItems(
                              title: "Mobile",
                              subtitle:
                                  authController.currentUser.value?.phonenumber,
                              icon: Icons.phone_android_sharp);
                        }),
                      ],
                    ),
                  )),
              SizedBox(height: 10),
              majorTitle(title: "Settings", color: Colors.black, size: 18.0),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                child: Column(
                  children: [
                    accountCard(
                        title: "Edit Profile",
                        icon: Icons.edit,
                        onPressed: () {
                          Get.to(() => ProfileUpdate());
                        }),
                    accountCard(
                        title: "Password Settings",
                        icon: Icons.lock,
                        onPressed: () {
                          showPasswordResetDialog(context,
                              "${authController.currentUser.value?.id}");
                        }),
                    accountCard(
                        title: "Subscriptions",
                        icon: Icons.subscriptions,
                        onPressed: () {}),
                    accountCard(
                        title: "Delete Account",
                        icon: Icons.delete,
                        onPressed: () {
                          deleteDialog(
                              context: context,
                              onPressed: () {
                                authController.deleteAdmin(
                                    context: context,
                                    id: authController.currentUser.value?.id);
                              });
                        }),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Card(
                elevation: 3,
                child: accountCard(
                    title: "Logout",
                    icon: Icons.logout,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text("Logout"),
                              content: majorTitle(
                                  title: "You will be logout from you account",
                                  color: Colors.grey,
                                  size: 14.0),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: majorTitle(
                                        title: "Cancel",
                                        color: AppColors.mainColor,
                                        size: 16.0)),
                                TextButton(
                                    onPressed: () {
                                      Get.back();
                                      authController.logout();
                                    },
                                    child: majorTitle(
                                        title: "Logout",
                                        color: AppColors.mainColor,
                                        size: 16.0))
                              ],
                            );
                          });
                    }),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget accountCard({required title, required icon, required onPressed}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: InkWell(
        onTap: () {
          onPressed();
          print("hello");
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: AppColors.mainColor),
                  SizedBox(width: 10),
                  majorTitle(title: title, color: Colors.grey, size: 16.0),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget profileItems({required title, required subtitle, required icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.mainColor),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(title: title, color: AppColors.mainColor, size: 18.0),
            SizedBox(height: 5),
            minorTitle(
              title: subtitle,
              color: Colors.black,
            )
          ],
        )
      ],
    );
  }
}

showPasswordResetDialog(BuildContext context, String id) {
  AuthController authController = Get.find<AuthController>();
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Center(child: Text("Edit Password")),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title: "New Password", color: Colors.black, size: 16.0),
                    SizedBox(height: 5),
                    TextFormField(
                      controller:
                          authController.textEditingControllerNewPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    )
                  ],
                ),
                SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title: "Confirm Password",
                        color: Colors.black,
                        size: 16.0),
                    SizedBox(height: 5),
                    TextFormField(
                      controller:
                          authController.textEditingControllerConfirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(3),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    )
                  ],
                ),
                Spacer(),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: majorTitle(
                            title: "CANCEL",
                            color: AppColors.mainColor,
                            size: 13.0)),
                    TextButton(
                        onPressed: () {
                          if (authController
                                      .textEditingControllerNewPassword.text ==
                                  "" ||
                              authController
                                      .textEditingControllerConfirmPassword
                                      .text ==
                                  "") {
                            showSnackBar(
                                message: "please fill all the fields",
                                color: Colors.red);
                          } else if (authController
                                  .textEditingControllerNewPassword.text !=
                              authController
                                  .textEditingControllerConfirmPassword.text) {
                            showSnackBar(
                                message: "Password mismatched",
                                color: Colors.red);
                          } else {
                            Get.back();
                            authController.updateUserPasswords(
                                authController.currentUser.value?.id, context);
                          }
                        },
                        child: majorTitle(
                            title: "UPDATE",
                            color: AppColors.mainColor,
                            size: 13.0)),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
