import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/roles_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/attendant_controller.dart';
import '../../models/attendant_model.dart';
import '../../widgets/attendant_user_inputs.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/switchingButton.dart';

class AttendantDetails extends StatelessWidget {
  AttendantModel attendantModel;

  AttendantDetails({Key? key, required this.attendantModel}) : super(key: key) {
    attendantController.getAttendantsById(attendantModel.id);
    attendantController.nameController.text = attendantModel.fullnames!;
  }

  AttendantController attendantController = Get.find<AttendantController>();
  AuthController authController = Get.find<AuthController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Scaffold(
            appBar: _appBar(),
            body: Container(
              padding:
                  EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 300),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 1.0)
                  ]),
              child: Column(
                children: [
                  userDetails(context),
                  majorTitle(
                      title: "Roles & Permissions",
                      color: Colors.black,
                      size: 14.0),
                  SizedBox(height: 10),
                  rolesWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  deleteAttendant(context)
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 10),
                  majorTitle(
                      title: "Roles & Permissions",
                      color: Colors.black,
                      size: 14.0),
                  SizedBox(height: 10),
                  rolesWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  deleteAttendant(context),
                ],
              ),
            ),
          ),
          appBar: _appBar(),
          bottomNavigationBar: BottomAppBar(
            // clipBehavior: Clip.antiAlias,
            // elevation: 0.5,
            color: Colors.white,
            child: Obx(() => Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  height: kToolbarHeight * 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: attendantController.creatingAttendantsLoad.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            attendantController.updateAttedant(
                                id: attendantModel.id,
                                rolesData: attendantModel.roles);
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
                )),
          ),
        ));
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0.3,
      titleSpacing: 0.0,
      centerTitle: false,
      backgroundColor: Colors.white,
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
          title: attendantModel.fullnames, color: Colors.black, size: 16.0),
    );
  }

  Widget deleteAttendant(context) {
    return InkWell(
      onTap: () {
        deleteDialog(
            context: context,
            onPressed: () {
              attendantController.deleteAttendant(
                  id: attendantModel.id,
                  context: context,
                  shopId: shopController.currentShop.value?.id);
            });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
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
                      title: "Delete Attendant",
                      color: Colors.black,
                      size: 16.0),
                  minorTitle(
                    title: "Attendant will be removed from shop",
                    color: Colors.grey,
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.delete)
            ],
          ),
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
        Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                showUpdatePasswordDialog(
                    context: context, attendantModel: attendantModel);
              },
              child: majorTitle(
                  title: "Update Password",
                  color: AppColors.mainColor,
                  size: 17.0),
            )),
      ],
    );
  }

  Widget rolesWidget() {
    return Obx(() {
      return attendantController.getAttendantByIdLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: attendantController.rolesFromApi.length,
                    itemBuilder: (context, int) {
                      RolesModel role = attendantController.rolesFromApi[int];
                      return switchingButtons(
                          title: role.name,
                          value: attendantModel.roles!.indexWhere(
                                      (element) => element.key == role.key) !=
                                  -1
                              ? true
                              : false,
                          function: () {
                            if (attendantModel.roles!.indexWhere(
                                    (element) => element.key == role.key) ==
                                -1) {
                              attendantModel.roles!.add(role);
                            } else {
                              attendantModel.roles!.removeWhere(
                                  (element) => element.key == role.key);
                            }
                          });
                    }),
              ),
            );
    });
  }
}

showUpdatePasswordDialog(
    {required BuildContext context, required AttendantModel attendantModel}) {
  AttendantController attendantController = Get.find<AttendantController>();
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
                  Get.back();
                  attendantController.updatePassword(
                      id: attendantModel.id, context: context);
                },
                child: majorTitle(
                    title: "Okay", color: AppColors.mainColor, size: 13.0))
          ],
        );
      });
}
