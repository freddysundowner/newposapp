import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/services/admin.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_model.dart';
import '../screens/home/home.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> signupkey = GlobalKey();
  GlobalKey<FormState> loginKey = GlobalKey();
  RxBool signuserLoad = RxBool(false);
  RxBool loginuserLoad = RxBool(false);
  RxBool updateAdminLoad = RxBool(false);
  Rxn<AdminModel> currentUser = Rxn(null);

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
          currentUser.value = adminModel;
          clearDataFromTextFields();
          Get.off(() => Home());
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
        if (response["error"] != null) {
          Get.snackbar("", "${response["error"]}",
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          AdminModel adminModel = AdminModel.fromJson(response["body"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", adminModel.id!);
          prefs.setString("token", response["token"]);
          currentUser.value = adminModel;
          clearDataFromTextFields();
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
        showSnackBar(message:response["message"], color: AppColors.mainColor);
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
}
