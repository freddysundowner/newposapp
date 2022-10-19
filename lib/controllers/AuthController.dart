import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/services/user.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../screens/home.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> signupkey = GlobalKey();
  GlobalKey<FormState> loginKey = GlobalKey();
  RxBool signuserLoad = RxBool(false);
  RxBool loginuserLoad = RxBool(false);

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
        var response = await User().createAdmin(body: body);
        signuserLoad.value = false;
        if (response["status"]==false) {
          Get.snackbar("", "${response["message"]}",
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          UserModel adminModel = UserModel.fromJson(response["body"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", adminModel.id!);
          prefs.setString("token", response["token"]);
          nameController.text = "";
          emailController.text = "";
          phoneController.text = "";
          passwordController.text = "";
          Get.off(()=>Home());
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
        var response = await User().loginAdmin(body: body);
        loginuserLoad.value = false;
        if (response["error"] !=null) {
          Get.snackbar("", "${response["error"]}",
              backgroundColor: Colors.red, colorText: Colors.white);
        } else {
          UserModel adminModel = UserModel.fromJson(response["body"]);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userId", adminModel.id!);
          prefs.setString("token", response["token"]);
          nameController.text = "";
          emailController.text = "";
          phoneController.text = "";
          passwordController.text = "";
          Get.off(()=>Home());
        }
        signuserLoad.value = false;
      } catch (e) {
        loginuserLoad.value = false;

      }

    } else {
      showSnackBar(message: "please fill all fields", color: Colors.red);
    }
  }

}
