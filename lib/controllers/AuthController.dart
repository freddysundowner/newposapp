import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/screens/authentication/landing.dart';
import 'package:pointify/services/users.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../screens/home/home.dart';
import '../screens/shop/create_shop.dart';
import '../widgets/snackBars.dart';
import 'home_controller.dart';

class AuthController extends GetxController {
  RxString id = RxString("");
  Rxn<Uri> baseUrl = Rxn(null);
  Rxn<App> app = Rxn(null);
  Rxn<User?> currentUser = Rxn(null);
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

  void initialize(String appId) {
    app.value = App(AppConfiguration(appId));
  }

  login(context) async {
    if (loginKey.currentState!.validate()) {
      try {
        loginuserLoad.value = true;
        await logInUserEmailPassword(
            emailController.text, passwordController.text);
        await Get.find<UserController>().getUser();
        Get.offAll(() => Home());
      } catch (e) {
        showSnackBar(message: "wrong username or password", color: Colors.red);
        loginuserLoad.value = false;
      } finally {
        loginuserLoad.value = false;
      }
    } else {
      showSnackBar(message: "please fill all fields", color: Colors.red);
    }
  }

  signUser(context) async {
    if (signupkey.currentState!.validate()) {
      try {
        signuserLoad.value = true;
        await registerUserEmailPassword(
            emailController.text, passwordController.text);
        User loggedInUser = await logInUserEmailPassword(
            emailController.text, passwordController.text);
        Users.createUser(UserModel(
          ObjectId.fromHexString(loggedInUser.id),
          usertype: "admin",
          fullnames: nameController.text,
        ));
        clearDataFromTextFields();
        await Get.find<UserController>().getUser();
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value =
              CreateShop(page: "home");
        } else {
          Get.off(() => CreateShop(page: "home"));
        }

        signuserLoad.value = false;
      } catch (e) {
        print(e);
        showSnackBar(
            message: "error creating account, try another email",
            color: Colors.red);
        signuserLoad.value = false;
      }
    } else {
      showSnackBar(message: "please fill all fields", color: Colors.red);
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
    currentUser.value = loggedInUser;
    Get.find<RealmController>().auth();
    return loggedInUser;
  }

  Future<User> registerUserEmailPassword(String email, String password) async {
    EmailPasswordAuthProvider authProvider =
        EmailPasswordAuthProvider(app.value!);
    await authProvider.registerUser(email, password);
    User loggedInUser =
        await app.value!.logIn(Credentials.emailPassword(email, password));
    currentUser.value = loggedInUser;
    return loggedInUser;
  }

  Future<void> logOut() async {
    await Get.find<RealmController>().currentUser!.value?.logOut();
    Get.find<RealmController>().currentUser?.value = null;
    refresh();
    Get.offAll(() => Landing());
  }
}
