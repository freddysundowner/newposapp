import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/authentication/landing.dart';
import 'package:pointify/screens/authentication/reloadpage.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/services/users.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../screens/shop/create_shop.dart';
import '../widgets/alert.dart';
import '../widgets/snackBars.dart';
import 'home_controller.dart';

class AuthController extends GetxController {
  RxString id = RxString("");
  Rxn<Uri> baseUrl = Rxn(null);
  Rxn<App> app = Rxn(null);
  RxBool showPassword = true.obs;
  ShopController shopController = Get.put(ShopController());
  TextEditingController passwordControllerConfirm = TextEditingController();
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

  GlobalKey<FormState> loginKey = GlobalKey();
  GlobalKey<FormState> signupkey = GlobalKey();
  GlobalKey<FormState> adminresetPassWordFormKey = GlobalKey();
  GlobalKey<FormState> loginAttendantKey = GlobalKey();
  RxBool signuserLoad = RxBool(false);
  RxBool loginuserLoad = RxBool(false);
  RxBool updateAdminLoad = RxBool(false);
  RxBool getUserByIdLoad = RxBool(false);
  RxBool LoginAttendantLoad = RxBool(false);

  void initialize(String appId) {
    app.value = App(AppConfiguration(appId));
  }

  login(context) async {
    if (loginKey.currentState!.validate()) {
      try {
        loginuserLoad.value = true;
        await logInUserEmailPassword(
            emailController.text, passwordController.text);
        await Get.find<UserController>().getUser(type: "login");
      } catch (e) {
        showSnackBar(message: "wrong username or password", color: Colors.red);
        loginuserLoad.value = false;
      }
    } else {
      showSnackBar(message: "please fill all fields", color: Colors.red);
    }
  }

  attendantLogin(context) async {
    if (attendantPasswordController.text.isEmpty ||
        attendantUidController.text.isEmpty) {
      generalAlert(title: "Error", message: "Enter user id");
      return;
    }
    try{
      LoginAttendantLoad.value = true;
      var password = attendantPasswordController.text;
      var uid = int.parse(attendantUidController.text);

      Get.put(RealmController()).auth();
      var response = await Users.getAttendantbyUid(uid.toString());
      if (kDebugMode) {
        print("response is $response");
      }
      var userdata = response["user"];
      if (userdata["_id"] != null) {
        var email = userdata["email"];
        if (userdata["loggedin"] == null) {
          await registerUserEmailPassword(email!, password);

          appController.initialize(appId);
          User? loggedInUser = await logInUserEmailPassword(email!, password);
          appController.initialize(appId);

          var uid = userdata["UNID"];
          final updatedCustomUserData = {
            "uid": uid,
            "authId": loggedInUser.id,
            "loggedin": true,
          };
          loggedInUser.functions.call("createAttendantMeta", [updatedCustomUserData]).then((value) {
            attendantUidController.clear();
            attendantPasswordController.clear();

            Get.offAll(() => const ReloadPage());
          });
          LoginAttendantLoad.value = false;
          await loggedInUser.refreshCustomData();
        } else {
          try {
            appController.initialize(appId);
            await logInUserEmailPassword(email!, password);
            appController.initialize(appId);
            LoginAttendantLoad.value = false;
            Get.offAll(() => const ReloadPage());
          } catch (e) {
            if (kDebugMode) {
              print(e);
            }
            LoginAttendantLoad.value = false;
            showSnackBar(message: "wrong password", color: Colors.red);
          }
        }
      } else {
        LoginAttendantLoad.value = false;
        generalAlert(title: "Error", message: "UID supplied does not exist");
      }
      LoginAttendantLoad.value = false;
    }catch(e){
      LoginAttendantLoad.value = false;
      generalAlert(title: "Error", message: "UID supplied does not exist");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  signUser(context) async {
    if (signupkey.currentState!.validate()) {
      try {
        if (passwordController.text.toString().trim().length < 6) {
          generalAlert(
              title: "Error",
              message: "Password must be more than 6 charactes");
          return;
        }
        signuserLoad.value = true;
        await registerUserEmailPassword(
            emailController.text, passwordController.text);
        User loggedInUser = await logInUserEmailPassword(
            emailController.text, passwordController.text);
        Users.createUser(UserModel(
          ObjectId.fromHexString(loggedInUser.id),
          Random().nextInt(098459),
          usertype: "admin",
          deleted: false,
          email: emailController.text,
          phonenumber: phoneController.text,
          username: "Admin",
          authId: loggedInUser.id,
          fullnames: nameController.text,
        ));
        clearDataFromTextFields();
        await Get.find<UserController>().getUser();
        Get.find<PlanController>().getPlans();
        if (isSmallScreen(context)) {
          Get.off(() => CreateShop(
                page: "home",
                clearInputs: true,
              ));
        } else {
          Get.off(() => CreateShop(page: "home", clearInputs: true));
        }

        signuserLoad.value = false;
      } catch (e) {
        print(e);
        showSnackBar(
            message: "error creating account, try another email",
            color: Colors.red);
        signuserLoad.value = false;
      }
    }
  }

  clearDataFromTextFields() {
    nameController.text = "";
    emailController.text = "";
    phoneController.text = "";
    passwordController.text = "";
  }

  Future<User> logInUserEmailPassword(String email, String password) async {
    User loggedInUser =
        await app.value!.logIn(Credentials.emailPassword(email, password));

    Get.put(RealmController()).currentUser?.value = loggedInUser;
    Get.put(RealmController()).auth();
    return loggedInUser;
  }

  Future<User> registerUserEmailPassword(String email, String password) async {
    EmailPasswordAuthProvider authProvider =
        EmailPasswordAuthProvider(app.value!);
    await authProvider.registerUser(email, password);
    User loggedInUser =
        await app.value!.logIn(Credentials.emailPassword(email, password));
    Get.find<RealmController>().currentUser?.value = loggedInUser;
    return loggedInUser;
  }

  Future<void> logOut() async {
    await Get.find<RealmController>().currentUser!.value?.logOut();
    Get.find<RealmController>().currentUser?.value = null;
    Get.offAll(() => Landing());
    Get.find<HomeController>().activeItem.value = "Home";
    Get.find<HomeController>().selectedWidget.value = HomePage();
    refresh();
  }

  void resetPasswordEmail(
      {required String email, required String password, required type}) {
    app.value!.emailPasswordAuthProvider
        .callResetPasswordFunction(email, password);

    generalAlert(
        title: "Done",
        message: "password reset successful",
        negativeText: "",
        function: () {
          Get.back();
          Get.back();
          if (type == "admin") {
            logOut();
          }
        });
    if (type == "admin") {
      Timer(const Duration(milliseconds: 2000), () {
        logOut();
      });
    }
  }

  validateEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
