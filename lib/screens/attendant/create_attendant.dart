import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/models/roles_model.dart';
import 'package:get/get.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/attendant_user_inputs.dart';
import '../../widgets/bigtext.dart';

class CreateAttendant extends StatelessWidget {
  CreateAttendant({Key? key}) : super(key: key);
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              majorTitle(
                  title: "Attendant Credentials",
                  color: Colors.black54,
                  size: 14.0),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      attendantUserInputs(
                          name: "Attendant Username",
                          controller: attendantController.nameController),
                      SizedBox(height: 10),
                      attendantUserInputs(
                          name: "Attendant Password",
                          controller: attendantController.passwordController)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              majorTitle(
                  title: "Roles & Permissions",
                  color: Colors.black,
                  size: 14.0),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Obx(() {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: attendantController.rolesFromApi.length,
                      shrinkWrap: true,
                      itemBuilder: (context, int) {
                        RolesModel role =
                            attendantController.rolesFromApi.elementAt(int);
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
        ),
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
                : InkWell(
                    onTap: () {
                      attendantController.saveAttendant(
                          shopId: shopController.currentShop.value?.id);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: majorTitle(
                              title: "Create Attendant",
                              color: AppColors.mainColor,
                              size: 18.0)),
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
