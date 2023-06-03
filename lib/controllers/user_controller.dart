import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/main.dart';
import 'package:realm/realm.dart';

import '../Real/Models/schema.dart';
import '../Real/services/r_shop.dart';
import '../services/users.dart';

class UserController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  RxBool creatingAttendantsLoad = RxBool(false);
  RxBool getAttendantsLoad = RxBool(false);
  RxBool getAttendantByIdLoad = RxBool(false);
  RxList<UserModel> users = RxList([]);
  Rxn<UserModel> user = Rxn(null);
  RxList<RolesModel> roles = RxList([]);
  RxList<RolesModel> rolesFromApi = RxList([]);

  RxString activeItem = RxString("");
  ShopController shopController = Get.find<ShopController>();

  getUser() async {
    print("getUser");
    RealmResults<UserModel> userdata = await Users.getUserUser();
    if (userdata.length == 0) {
      await appController.logOut();
      return;
    }
    print("getUser ${userdata.length}");
    user.value = userdata.first;
    print("getUser ${userdata.first}");
    if (userdata.isNotEmpty &&
        userdata.map((e) => e).toList().first.shop != null) {
      shopController.currentShop.value =
          userdata.map((e) => e).toList().first.shop;
    } else {
      RealmResults<Shop> response = await RShop().getShop();
      if (response.isNotEmpty) {
        shopController.currentShop.value = response.first;
      }
    }
    shopController.currentShop.refresh();
  }

  saveAttendant({required shopId, required context}) async {
    // String name = nameController.text;
    // String password = passwordController.text;
    // if (name == "" || password == "") {
    //   showSnackBar(message: "please fill all the fields", color: Colors.red);
    // } else {
    //   try {
    //     creatingAttendantsLoad.value = true;
    //     var response = await Attendant().createAttendant(AttendantModel(
    //       ObjectId(),
    //       fullnames: nameController.text,
    //       shop: shopId,
    //       roles: roles,
    //     ));
    //     if (response["status"] = true) {
    //       clearTextFields();
    //       if (MediaQuery.of(context).size.width > 600) {
    //         Get.find<HomeController>().selectedWidget.value = AttendantsPage();
    //       } else {
    //         Get.back();
    //       }
    //       getAttendantsByShopId(shopId: shopId);
    //     } else {
    //       showSnackBar(
    //           message: response["message"], color: AppColors.mainColor);
    //     }
    //
    //     creatingAttendantsLoad.value = false;
    //   } catch (e) {
    //     creatingAttendantsLoad.value = false;
    //   }
    // }
  }

  getAttendantRoles() async {
    // try {
    //   RealmResults<RolesModel> response = await Attendant().getRoles();
    //   rolesFromApi.clear();
    //   if (response.isNotEmpty) {
    //     rolesFromApi.assignAll(response);
    //   } else {
    //     rolesFromApi.value = [];
    //   }
    // } catch (e) {}
  }

  getAttendantsByShopId({required shopId}) async {
    // try {
    //   getAttendantsLoad.value = true;
    //   RealmResults<AttendantModel> response =
    //       await Attendant().getAttendantsByShopId(shopId);
    //   if (response.isNotEmpty) {
    //     attendants.assignAll(response);
    //   } else {
    //     attendants.value = [];
    //   }
    //   getAttendantsLoad.value = false;
    // } catch (e) {
    //   getAttendantsLoad.value = false;
    // }
  }

  clearTextFields() {
    nameController.text = "";
    passwordController.text = "";
  }

  getAttendantsById(id) async {
    // try {
    //   getAttendantByIdLoad.value = true;
    //   RealmResults<AttendantModel> response =
    //       await Attendant().getAttendantById(id);
    //   getAttendantByIdLoad.value = false;
    //   if (response.isEmpty) {
    //     Get.find<AuthController>().logout();
    //   }
    //   AttendantModel userModel = response.first;
    //   attendant.value = userModel;
    //   return userModel;
    // } catch (e) {
    //   getAttendantByIdLoad.value = false;
    // }
  }

  updatePassword({required id, required BuildContext context}) async {
    // try {
    //   Map<String, dynamic> body = {"password": passwordController.text};
    //   LoadingDialog.showLoadingDialog(
    //       context: context,
    //       title: "Updating password please wait...",
    //       key: _keyLoader);
    //   await Attendant().updatePassword(id, body);
    //   Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // } catch (e) {
    //   Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // }
  }

  deleteAttendant(
      {required id, required BuildContext context, required shopId}) async {
    // try {
    //   LoadingDialog.showLoadingDialog(
    //       context: context,
    //       title: "Deleting attendant please wait...",
    //       key: _keyLoader);
    //   var response = await Attendant().deleteAttendant(id);
    //   Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    //   if (response["status"] == true) {
    //     if (MediaQuery.of(context).size.width > 600) {
    //       Get.find<HomeController>().selectedWidget.value = AttendantsPage();
    //     } else {
    //       Get.back();
    //     }
    //
    //     getAttendantsByShopId(shopId: shopId);
    //   } else {
    //     showSnackBar(message: response["message"], color: AppColors.mainColor);
    //   }
    // } catch (e) {
    //   Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    // }
  }
  //
  // updateAttedant(
  //     {required id,
  //     required List<RolesModel> rolesData,
  //     BuildContext? context}) async {
  //   try {
  //     if (rolesData.isEmpty) {
  //       generalAlert(
  //           title: "Error", message: "Add atleast one role to this attendant");
  //       return;
  //     }
  //     creatingAttendantsLoad.value = true;
  //     Map<String, dynamic> body = {
  //       "fullnames": nameController.text,
  //       "roles": rolesData,
  //     };
  //     var response = await Attendant().updateAttendant(id: id, body: body);
  //     if (response != null) {
  //       int index = attendants.indexWhere((element) => element.id == id);
  //       if (index != -1) {
  //         attendants[index] = AttendantModel.fromJson(response);
  //         attendants.refresh();
  //         if (MediaQuery.of(context!).size.width > 600) {
  //           Get.find<HomeController>().selectedWidget.value = AttendantsPage();
  //         } else {
  //           Get.back();
  //         }
  //       }
  //     }
  //     creatingAttendantsLoad.value = false;
  //   } catch (e) {
  //     print(e);
  //     creatingAttendantsLoad.value = false;
  //   }
  // }

  checkRole(String key) {
    // return attendant.value!.roles!
    //         .indexWhere((element) => element.key == key) !=
    //     -1;
  }
}
