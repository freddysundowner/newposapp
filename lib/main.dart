import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/responsive/Appbehaviour.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/services/shop_services.dart';
import 'package:pointify/bindings.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/screens/home/home.dart';
import 'package:pointify/screens/authentication/landing.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/services/users.dart';
import 'package:pointify/utils/colors.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import 'package:window_size/window_size.dart';
import 'controllers/AuthController.dart';
import 'controllers/realm_controller.dart';

final AuthController appController = Get.put(AuthController());
final RealmController realmServices = Get.put(RealmController());
UserController userController = Get.put<UserController>(UserController());
String appId = 'application-0-iosyj';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appController.initialize(appId);
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowMinSize(const Size(800, 700));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  PlanController planController = Get.put<PlanController>(PlanController());
  HomeController homeController = Get.put<HomeController>(HomeController());
  final RealmController realmService = Get.put(RealmController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pointify:',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: ThemeData(
          primarySwatch: AppColors.mainColor,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory),
      initialBinding: AuthBinding(),
      home: Authenticate(),
    );
  }
}

class Authenticate extends StatelessWidget {
  Authenticate({Key? key}) : super(key: key);

  _auth() {
    if (realmServices.currentUser!.value != null) {
      RealmResults<UserModel> users = Users.getUserUser();
      userController.getUser();
      if (users.isNotEmpty) {
        if (users.first.usertype == "attendant") {
          return Scaffold(
            body: SafeArea(
              child: isSmallScreen(Get.context) ? HomePage() : Home(),
            ),
          );
        } else {
          var shop = ShopService().getShop();
          if (shop.isEmpty) {
            return CreateShop(
              page: "home",
              clearInputs: true,
            );
          } else {
            return Home();
          }
        }
      } else {
        return Landing();
      }
    } else {
      return Landing();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _auth(),
    );
  }
}
