import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/screens/home/profile_page.dart';
import 'package:flutterpos/screens/shop/create_shop.dart';
import 'package:flutterpos/services/admin.dart';
import 'package:flutterpos/services/attendant.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_model.dart';
import '../screens/attendant/attendant_landing.dart';
import '../screens/home/home.dart';
import '../screens/landing/landing.dart';
import '../widgets/loading_dialog.dart';

class AuthController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ShopController shopController = Get.put(ShopController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController textEditingControllerNewPassword =
      TextEditingController();
  TextEditingController textEditingControllerConfirmPassword =
      TextEditingController();
  TextEditingController attendantUidController = TextEditingController();
  TextEditingController attendantPasswordController = TextEditingController();

  GlobalKey<FormState> signupkey = GlobalKey();
  GlobalKey<FormState> loginKey = GlobalKey();
  GlobalKey<FormState> loginAttendantKey = GlobalKey();
  RxBool signuserLoad = RxBool(false);
  RxBool loginuserLoad = RxBool(false);
  RxBool updateAdminLoad = RxBool(false);
  RxBool getUserByIdLoad = RxBool(false);
  RxBool LoginAttendantLoad = RxBool(false);
  Rxn<AdminModel> currentUser = Rxn(null);
  RxString usertype = RxString("admin");

  signUser(context) async {
    if (signupkey.currentState!.validate()) {
      try {
        signuserLoad.value = true;
        Map<String, dynamic> body = {
          "name": nameController.text,
          "email": emailController.text,
          "phonenumber": phoneController.text,
          "password": passwordController.text,
        };
        var response = await Admin().createAdmin(body: body);
        signuserLoad.value = false;
        if (response["status"] == false) {
          showSnackBar(
              message: "${response["message"]}",
              color: Colors.red,
              context: context);
        } else {
          AdminModel adminModel = AdminModel.fromJson(response["body"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", adminModel.id!);
          prefs.setString("token", response["token"]);
          prefs.setString("type", "admin");
          currentUser.value = adminModel;
          clearDataFromTextFields();
          usertype.value = "admin";
          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value =
                CreateShop(page: "home");
          } else {
            Get.off(() => CreateShop(page: "home"));
          }
        }
        signuserLoad.value = false;
      } catch (e) {
        signuserLoad.value = false;
      }
    } else {
      showSnackBar(
          message: "please fill all fields",
          color: Colors.red,
          context: context);
    }
  }

  login(context) async {
    if (loginKey.currentState!.validate()) {
      try {
        loginuserLoad.value = true;
        Map<String, dynamic> body = {
          "email": emailController.text,
          "password": passwordController.text,
        };
        var response = await Admin().loginAdmin(body: body);
        loginuserLoad.value = false;
        if (response["error"] != null) {
          showSnackBar(
              message: "${response["error"]}",
              color: Colors.red,
              context: context);
        } else {
          AdminModel adminModel = AdminModel.fromJson(response["body"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", adminModel.id!);
          prefs.setString("token", response["token"]);
          prefs.setString("type", "admin");

          currentUser.value = adminModel;
          clearDataFromTextFields();
          shopController.currentShop.value =
              adminModel.shops!.isNotEmpty ? adminModel.shops![0] : null;
          usertype.value = "admin";
          Get.off(() => Home());
        }
        signuserLoad.value = false;
      } catch (e) {
        usertype.value = "admin";
        loginuserLoad.value = false;
      }
    } else {
      showSnackBar(
          message: "please fill all fields",
          color: Colors.red,
          context: context);
    }
  }

  getUserById() async {
    try {
      getUserByIdLoad.value = true;
      String id = await getUserId();
      var user = await Admin().getUserById(id);
      if (user["status"] == false) {
        getUserByIdLoad.value = false;
        logout();
      }

      getUserByIdLoad.value = false;
      AdminModel userModel = AdminModel.fromJson(user["body"]);
      shopController.currentShop.value =
          userModel.shops!.isNotEmpty ? userModel.shops![0] : null;
      currentUser.value = userModel;
      return userModel;
    } catch (e) {
      getUserByIdLoad.value = false;
    }
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("userId");
    return user;
    // return "63f9efe3879e16801054a0b0";
  }

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("type");
    if (user == "admin") {
      AdminModel adminModel = await getUserById();
      return ["admin", adminModel];
    } else {
      String? id = await getUserId();
      if (id != null) {
        AttendantModel attendantModel =
            await Get.find<AttendantController>().getAttendantsById(id);
        return ["attendant", attendantModel];
      }
    }
  }

  updateAdmin(context) async {
    try {
      updateAdminLoad.value = true;
      Map<String, dynamic> body = {
        if (emailController.text != "") "email": emailController.text,
        if (phoneController.text != "") "phonenumber": phoneController.text,
        if (nameController.text != "") "name": nameController.text,
      };
      var response =
          await Admin().updateAdmin(body: body, id: currentUser.value?.id);
      print("updated response is${response}");

      if (response["status"] == true) {
        clearDataFromTextFields();
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = ProfilePage();
        } else {
          Get.back();
        }
        getUserById();
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
      updateAdminLoad.value = false;
    } catch (e) {
      updateAdminLoad.value = false;
    }
  }

  assignDataToTextFields() {
    nameController.text =
        currentUser.value == null ? "" : currentUser.value!.name!;
    emailController.text =
        currentUser.value == null ? "" : currentUser.value!.email!;
    phoneController.text =
        currentUser.value == null ? "" : currentUser.value!.phonenumber!;
  }

  clearDataFromTextFields() {
    nameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    shopController.currentShop.value = null;
    usertype.value = "";
    clearDataFromTextFields();
    Get.offAll(() => Landing());
  }

  deleteAdmin({required BuildContext context, required id}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context,
          title: "Deleting your account please wait...",
          key: _keyLoader);
      var response = await Admin().deleteAdmin(id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == false) {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      } else {
        showSnackBar(
            message: response["message"],
            color: Colors.redAccent,
            context: context);
        Get.find<AuthController>().getUserById();
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  updateUserPasswords(String? id, BuildContext context) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context,
          title: "Updating password please wait...",
          key: _keyLoader);
      Map<String, dynamic> body = {
        "password": textEditingControllerNewPassword.text
      };
      await Admin().updatePassword(id: id, body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      // if (response["status"] == true) {
      //   showSnackBar(
      //       message: response["message"],
      //       color: AppColors.mainColor,
      //       context: context);
      // } else {
      //   showSnackBar(
      //       message: response["message"],
      //       color: AppColors.mainColor,
      //       context: context);
      // }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  loginAttendant(context) async {
    try {
      if (loginAttendantKey.currentState!.validate()) {
        LoginAttendantLoad.value = true;
        Map<String, dynamic> data = {
          "attend_id": attendantUidController.text,
          "password": attendantPasswordController.text,
        };
        var response = await Attendant().loginAttendant(body: data);

        if (response["error"] != null) {
          String message = response["error"];
          Get.snackbar("", message,
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          AttendantModel attendantModel =
              AttendantModel.fromJson(response["body"]);
          Get.find<AttendantController>().attendant.value = attendantModel;
          Get.find<ShopController>().currentShop.value = attendantModel.shop;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", attendantModel.id!);
          prefs.setString("token", response["token"]);
          prefs.setString("type", "attendant");
          attendantUidController.text = "";
          attendantPasswordController.text = "";
          usertype.value = "attendant";
          Get.offAll(() => AttendantLanding());
        }
        LoginAttendantLoad.value = false;
      } else {}
    } catch (e) {
      LoginAttendantLoad.value = false;
    }
  }
}
