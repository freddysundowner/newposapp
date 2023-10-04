import 'package:flutter/material.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:get/get.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:realm/src/user.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/home_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/logout.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/snackBars.dart';
import '../profile/profile_update.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  RealmController authController =
      Get.put(RealmController()); //<RealmService>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            // isSmallScreen(context)
            //     ?
            SafeArea(
      child: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen(context) ? 10 : 20, vertical: 10)
            .copyWith(right: isSmallScreen(context) ? 10 : 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            majorTitle(title: "User Details", color: Colors.black, size: 18.0),
            const SizedBox(height: 10),
            Card(
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return profileItems(
                            title: "Email",
                            subtitle: authController
                                .currentUser!.value?.profile.email,
                            icon: Icons.email);
                      }),
                      const SizedBox(height: 15),
                      if(userController.user.value!.username !=null)Obx(() {
                        return profileItems(
                            title: "Username",
                            subtitle: userController.user.value!.username ?? "",
                            icon: Icons.person);
                      }),
                    ],
                  ),
                )),
            const SizedBox(height: 10),
            majorTitle(title: "Settings", color: Colors.black, size: 18.0),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              child: Column(
                children: [
                  accountCard(
                      title: "Edit Profile",
                      icon: Icons.edit,
                      onPressed: () {
                        if (isSmallScreen(context)) {
                          Get.to(() => ProfileUpdate());
                        } else {
                          Get.find<HomeController>().selectedWidget.value =
                              ProfileUpdate();
                        }
                      }),
                  accountCard(
                      title: "Password Settings",
                      icon: Icons.lock,
                      onPressed: () {
                        showPasswordResetDialog(
                            authController.currentUser!.value!.profile);
                      }),
                  accountCard(
                      showDivider: false,
                      title: "Delete Account",
                      icon: Icons.delete,
                      onPressed: () {
                        deleteDialog(
                            context: context,
                            onPressed: () {
                              authController.deleteAdmin();
                            });
                      }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (isSmallScreen(context))
              Card(
                elevation: 3,
                child: accountCard(
                  title: "Logout",
                  icon: Icons.logout,
                  showDivider: false,
                  onPressed: () {
                    logoutAccountDialog(context);
                  },
                ),
              ),
          ],
        ),
      )),
    ));
  }

  Widget accountCard(
      {required title,
      required icon,
      required onPressed,
      bool? showDivider = true}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: AppColors.mainColor),
                  const SizedBox(width: 10),
                  majorTitle(title: title, color: Colors.grey, size: 16.0),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (showDivider!)
                const Divider(
                  color: Colors.black,
                  thickness: 0.1,
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget accountCardDesktop({required title, required onPressed}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
      child: InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              majorTitle(title: title, color: Colors.grey, size: 16.0),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
              ),
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
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(title: title, color: AppColors.mainColor, size: 18.0),
            const SizedBox(height: 5),
            minorTitle(
              title: subtitle,
              color: Colors.black,
            )
          ],
        )
      ],
    );
  }

  showPasswordResetDialog(UserProfile profile) {
    AuthController authController = Get.find<AuthController>();
    showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertDialog(
            title: const Center(child: Text("Edit Password")),
            content: SizedBox(
              height: MediaQuery.of(Get.context!).size.height * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      majorTitle(
                          title: "New Password",
                          color: Colors.black,
                          size: 16.0),
                      const SizedBox(height: 5),
                      Obx(()=> TextFormField(
                          controller:
                              authController.textEditingControllerNewPassword,
                          obscureText: authController.showPassword.value,
                          decoration: InputDecoration(
                            suffix: InkWell(child: Icon(authController.showPassword.value ?Icons.visibility_off : Icons.visibility), onTap: (){
                              authController.showPassword.value = !authController.showPassword.value;
                            },),
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      majorTitle(
                          title: "Confirm Password",
                          color: Colors.black,
                          size: 16.0),
                      const SizedBox(height: 5),
                      Obx(()=> TextFormField(
                          controller:
                              authController.textEditingControllerConfirmPassword,
                          obscureText: authController.showPassword.value,
                          decoration: InputDecoration(
                            suffix: InkWell(child: Icon(authController.showPassword.value ?Icons.visibility_off : Icons.visibility), onTap: (){
                              authController.showPassword.value = !authController.showPassword.value;
                            },),
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
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
                            if (authController.textEditingControllerNewPassword
                                        .text ==
                                    "" ||
                                authController
                                        .textEditingControllerConfirmPassword
                                        .text ==
                                    "") {
                              generalAlert(
                                  message: "please fill all the fields",
                                  title: "Error");
                            } else if (authController
                                    .textEditingControllerNewPassword.text !=
                                authController
                                    .textEditingControllerConfirmPassword
                                    .text) {
                              generalAlert(
                                  message: "Password mismatched",
                                  title: "Error");
                            } else {
                              if (authController
                                      .textEditingControllerNewPassword.text
                                      .toString()
                                      .trim()
                                      .length <
                                  6) {
                                generalAlert(
                                    title: "Error",
                                    message:
                                        "Password must be more than 6 characters");
                                return;
                              }

                              authController.showPassword.value = true;
                              Get.back();
                              authController.resetPasswordEmail(
                                  profile.email!,
                                  authController
                                      .textEditingControllerConfirmPassword
                                      .text);
                              authController
                                  .textEditingControllerConfirmPassword.clear();
                              authController
                                  .textEditingControllerNewPassword.clear();

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
}
