import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/attendants_page.dart';
import 'package:get/get.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:realm/realm.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../Real/Models/schema.dart';
import '../../controllers/shop_controller.dart';
import '../../services/users.dart';
import '../../utils/colors.dart';
import '../../widgets/attendant_user_inputs.dart';
import '../../widgets/bigtext.dart';

class CreateAttendant extends StatelessWidget {
  CreateAttendant({Key? key}) : super(key: key) {
    attendantController.nameController.clear();
    attendantController.passwordController.clear();
  }

  final UserController attendantController = Get.find<UserController>();
  final ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.3,
          centerTitle: false,
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Get.find<HomeController>().selectedWidget.value =
                  AttendantsPage();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: majorTitle(
              title: "Create Attendant", color: Colors.black, size: 18.0),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1.0),
              color: Colors.white,
            ),
            padding: EdgeInsets.only(left: 30, top: 10, bottom: 20, right: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dataWidget(),
                SizedBox(height: 20),
                Obx(() {
                  return attendantController.creatingAttendantsLoad.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Container(
                            child: submitButton(context),
                            width: 200,
                          ),
                        );
                })
              ],
            ),
          ),
        ),
      ),
      smallScreen: Scaffold(
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: majorTitle(
              title: "Create Attendant", color: Colors.black, size: 18.0),
        ),
        body: SingleChildScrollView(
          child: dataWidget(),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(10),
            height: kBottomNavigationBarHeight * 1.5,
            child: Obx(() {
              return attendantController.creatingAttendantsLoad.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : submitButton(context);
            }),
          ),
        ),
      ),
    );
  }

  Widget dataWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                attendantUserInputs(
                    name: "Username",
                    controller: attendantController.nameController),
                // SizedBox(height: 10),
                // attendantUserInputs(
                //     name: "Attendant Password",
                //     controller: attendantController.passwordController)
              ],
            ),
          ),
          SizedBox(height: 10),
          majorTitle(
              title: "Roles & Permissions", color: Colors.black, size: 14.0),
          SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 5,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: StreamBuilder<RealmResultsChanges<RolesModel>>(
                  stream: Users.getAllRoles().changes,
                  builder: (context, snapshot) {
                    final data = snapshot.data;

                    if (data == null) {
                      return const Center(
                        child: Text("No purchase Entries Found"),
                      );
                    }

                    final results = data.results;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.realm.isClosed ? 0 : results.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int) {
                        RolesModel role = results.elementAt(int);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              majorTitle(
                                  title: "${role.name}",
                                  color: Colors.black,
                                  size: 12.0),
                              Spacer(),
                              SwitcherButton(
                                onColor: AppColors.mainColor,
                                offColor: Colors.grey,
                                value: false,
                                onChange: (value) {
                                  if (attendantController.roles.indexWhere(
                                          (element) =>
                                              element.key == role.key) ==
                                      -1) {
                                    attendantController.roles.add(role);
                                  } else {
                                    attendantController.roles.removeWhere(
                                        (element) => element.key == role.key);
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget submitButton(context) {
    return InkWell(
      onTap: () {
        if (attendantController.nameController.text.isEmpty) {
          generalAlert(title: "Error", message: "Enter username");
          return;
        }
        print("submitButton");
        RealmResults<UserModel> users = Users.getUserUser(
            username: attendantController.nameController.text.trim());
        print("users ${users.length}");
        if (users.isNotEmpty) {
          generalAlert(title: "Error", message: "username already taken");
          return;
        }
        // Users.createUser(UserModel(
        //   ObjectId(),
        //   Random().nextInt(100000),
        //   username: attendantController.nameController.text,
        //   usertype: "attendant",
        //   deleted: false,
        //   shop: shopController.currentShop.value,
        //   roles: attendantController.roles,
        // ));
        attendantController.roles.clear();
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: majorTitle(
                title: "Create Attendant",
                color: AppColors.mainColor,
                size: 18.0)),
      ),
    );
  }
}
