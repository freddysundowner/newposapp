import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/services/users.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../../../utils/colors.dart';
import '../../Real/Models/schema.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/home_controller.dart';
import '../../widgets/attendant_user_inputs.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/switchingButton.dart';
import '../home/attendants_page.dart';

class AttendantDetails extends StatelessWidget {
  UserModel userModel;

  AttendantDetails({Key? key, required this.userModel}) : super(key: key) {
    attendantController.nameController.text = userModel.username!;
    attendantController.attendantId.text = userModel.UNID.toString();
    attendantController.currentAttendant.value = userModel;
    attendantController.getRoles(userModel);
  }

  UserController attendantController = Get.find<UserController>();
  ShopController shopController = Get.find<ShopController>();
  _itemRow({required String key, required data, required catId}) {
    var permissions = attendantController.permissions[catId];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          majorTitle(
              title: key.capitalize!.replaceAll("_", " "),
              color: Colors.black,
              size: 14.0),
          Spacer(),
          Obx(
            () => SwitcherButton(
              onColor: AppColors.mainColor,
              offColor: Colors.grey,
              size: 40,
              value: attendantController.roles
                      .where((p0) => p0["key"] == permissions["key"])
                      .toList()
                      .isNotEmpty &&
                  attendantController.roles
                      .where((p0) => p0["key"] == permissions["key"])
                      .toList()[0]["value"]
                      .contains(key),
              onChange: (value) {
                String keyy = attendantController.permissions[catId]["key"];
                int i = attendantController.roles
                    .indexWhere((element) => element["key"] == keyy);
                if (i != -1) {
                  if (value == false) {
                    int ii = attendantController.roles[i]["value"]
                        .indexWhere((element) => element == key);
                    if (ii != -1) {
                      attendantController.roles[i]["value"].removeAt(ii);
                    }
                    if ((attendantController.roles[i]["value"] as List)
                        .isEmpty) {
                      attendantController.roles.removeAt(i);
                    }
                  } else {
                    attendantController.roles[i]["value"].add(key);
                  }
                } else {
                  var role = {
                    "key": keyy,
                    "value": [key]
                  };
                  attendantController.roles.addAll([role]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Scaffold(
            appBar: _appBar(context),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(
                    left: 30, top: 10, bottom: 10, right: 300),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userDetails(context),
                    majorTitle(
                        title: "Roles & Permissions",
                        color: Colors.black,
                        size: 14.0),
                    SizedBox(height: 10),
                    // rolesWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    deleteAttendant(context)
                  ],
                ),
              ),
            )),
        smallScreen: Helper(
          widget: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: userDetails(context),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => Scaffold(
                            appBar: AppBar(
                              title: Text("Permissions"),
                            ),
                            body: Container(
                              child: Obx(
                                () => ListView.builder(
                                  itemCount:
                                      attendantController.permissions.length,
                                  itemBuilder: (c, ii) {
                                    var role =
                                        attendantController.permissions[ii];
                                    var title = role["key"];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (attendantController
                                                    .activePermission.value ==
                                                title) {
                                              attendantController
                                                  .activePermission.value = "";
                                            } else {
                                              attendantController
                                                  .activePermission
                                                  .value = title;
                                            }
                                            attendantController.activePermission
                                                .refresh();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10,
                                                top: 10,
                                                left: 20,
                                                right: 20),
                                            child: Row(
                                              children: [
                                                Text(title
                                                    .toString()
                                                    .toUpperCase()),
                                                Spacer(),
                                                const Icon(Icons
                                                    .arrow_forward_ios_rounded)
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        Obx(() => attendantController
                                                    .activePermission.value !=
                                                role["key"]
                                            ? Container()
                                            : Container(
                                                height: double.parse(
                                                        (role["value"] as List)
                                                            .length
                                                            .toString()) *
                                                    35,
                                                margin: const EdgeInsets.only(
                                                    left: 20),
                                                child: ListView.builder(
                                                    itemCount:
                                                        (role["value"] as List)
                                                            .length,
                                                    itemBuilder: (c, i) {
                                                      var p = role["value"][i];
                                                      return _itemRow(
                                                          key: p,
                                                          data: role["value"],
                                                          catId: ii);
                                                    }),
                                              ))
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                            bottomNavigationBar: Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  var all = [];
                                  for (var element
                                      in attendantController.roles) {
                                    all.add({
                                      "key": element["key"],
                                      "value": jsonEncode(element["value"])
                                    });
                                  }
                                  print(jsonEncode(all));
                                  attendantController.updateAttedant(
                                      userModel: userModel,
                                      permissions: jsonEncode(all));
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
                                          title: "Update Changes",
                                          color: AppColors.mainColor,
                                          size: 18.0)),
                                ),
                              ),
                            ),
                          ));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 1,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                majorTitle(
                                    title: "Set Permissions",
                                    color: Colors.black,
                                    size: 16.0),
                                minorTitle(
                                  title: "give attendant permissions",
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            Spacer(),
                            Icon(Icons.lock)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: _appBar(context),
          bottomNavigationBar: BottomAppBar(
            // clipBehavior: Clip.antiAlias,
            // elevation: 0.5,
            color: Colors.white,
            child: Obx(() => Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: attendantController.creatingAttendantsLoad.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : deleteAttendant(context),
                )),
          ),
        ));
  }

  AppBar _appBar(context) {
    return AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      centerTitle: false,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = AttendantsPage();
          } else {
            Get.back();
          }
        },
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            majorTitle(
                title: userModel.username ?? userModel.username,
                color: Colors.black,
                size: 16.0),
            if (MediaQuery.of(context).size.width > 600)
              Obx(() {
                return InkWell(
                  onTap: () {
                    // attendantController.updateAttedant(
                    //   userModel: userModel,
                    // );
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.mainColor, width: 2),
                    ),
                    child: majorTitle(
                        title: "Update Changes",
                        color: AppColors.mainColor,
                        size: 14.0),
                  ),
                );
              })
          ],
        ),
      ),
    );
  }

  Widget deleteAttendant(context) {
    return InkWell(
      onTap: () {
        deleteDialog(
            context: context,
            onPressed: () {
              attendantController.deleteAttendant(userModel: userModel);
            });
      },
      child: SizedBox(
        width: double.infinity,
        height: 30,
        child: Center(
          child: majorTitle(
              title: "Remove Attendant", color: Colors.red, size: 16.0),
        ),
      ),
    );
  }

  Widget userDetails(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        attendantUserInputs(
            name: "Attendant Username",
            controller: attendantController.nameController),
        SizedBox(height: 15),
        attendantUserInputs(
            name: "Attendant ID",
            controller: attendantController.attendantId, //81975
            enabled: false),
        SizedBox(height: 15),
        Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                showUpdatePasswordDialog(
                    context: context, userModel: userModel);
              },
              child: majorTitle(
                  title: "Reset Password",
                  color: AppColors.mainColor,
                  size: 17.0),
            )),
      ],
    );
  }
}

showUpdatePasswordDialog(
    {required BuildContext context, required UserModel userModel}) {
  UserController attendantController = Get.find<UserController>();
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: majorTitle(
              title: "Update Password", color: Colors.black, size: 16.0),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                attendantUserInputs(
                    name: "New Password",
                    controller: attendantController.passwordController),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: majorTitle(
                    title: "Cancel", color: AppColors.mainColor, size: 13.0)),
            TextButton(
                onPressed: () {
                  // Get.back();
                  // attendantController.updatePassword(
                  //     id: userModel.id, context: context);
                },
                child: majorTitle(
                    title: "Okay", color: AppColors.mainColor, size: 13.0))
          ],
        );
      });
}
