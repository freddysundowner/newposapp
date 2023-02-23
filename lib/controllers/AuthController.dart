import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/screens/shop/create_shop.dart';
import 'package:flutterpos/services/admin.dart';
import 'package:flutterpos/services/attendant.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  RxString usertype = RxString("");

  signUser() async {
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
          showSnackBar(message: "${response["message"]}", color: Colors.red);
        } else {
          AdminModel adminModel = AdminModel.fromJson(response["body"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", adminModel.id!);
          prefs.setString("token", response["token"]);
          prefs.setString("type", "admin");
          currentUser.value = adminModel;
          clearDataFromTextFields();
          Get.off(() => CreateShop(page: "home"));
        }
        signuserLoad.value = false;
      } catch (e) {
        signuserLoad.value = false;
      }
    } else {
      showSnackBar(message: "please fill all fields", color: Colors.red);
    }
  }

  login() async {
    if (loginKey.currentState!.validate()) {
      try {
        loginuserLoad.value = true;
        Map<String, dynamic> body = {
          "email": emailController.text,
          "password": passwordController.text,
        };
        var response = await Admin().loginAdmin(body: body);
        loginuserLoad.value = false;
        if (response == null) {
          Get.snackbar("", "${response["error"]}",
              backgroundColor: Colors.red, colorText: Colors.white);
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
          Get.off(() => Home());
        }
        signuserLoad.value = false;
      } catch (e) {
        loginuserLoad.value = false;
      }
    } else {
      showSnackBar(message: "please fill all fields", color: Colors.red);
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
  }

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString("type");
    return user;
  }

  updateAdmin() async {
    try {
      updateAdminLoad.value = true;
      Map<String, dynamic> body = {
        if (emailController.text != "") "email": emailController.text,
        if (phoneController.text != "") "phone": phoneController.text,
        if (nameController.text != "") "name": nameController.text,
      };
      var response =
          await Admin().updateAdmin(body: body, id: currentUser.value?.id);
      if (response["status"] == true) {
        clearDataFromTextFields();
        Get.back();
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
      updateAdminLoad.value = false;
    } catch (e) {
      updateAdminLoad.value = false;
    }
  }

  assignDataToTextFields() {
    nameController.text = currentUser.value!.name!;
    emailController.text = currentUser.value!.email!;
    phoneController.text = currentUser.value!.phonenumber!;
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
        showSnackBar(message: response["message"], color: Colors.red);
      } else {
        showSnackBar(message: response["message"], color: Colors.redAccent);
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
      var response = await Admin().updatePassword(id: id, body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
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
        print(data);
        var response = await Attendant().loginAttendant(body: data);
        print(response);
        if (response["error"] != null) {
          String message = response["error"];
          Get.snackbar("", message,
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          AttendantModel attendantModel = AttendantModel.fromJson(response["body"]);
          Get.find<AttendantController>().attendant.value= attendantModel;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", attendantModel.id!);
          prefs.setString("token", response["token"]);
          prefs.setString("type", "attendant");
          attendantUidController.text = "";
          attendantPasswordController.text = "";
          Get.offAll(() => AttendantLanding());
        }
        LoginAttendantLoad.value = false;
      } else {
        print("form not validated");
      }
    } catch (e) {
      LoginAttendantLoad.value = false;
    }
  }

}
