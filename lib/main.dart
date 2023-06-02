import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointify/Real/services/r_shop.dart';
import 'package:pointify/bindings.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/screens/home/home.dart';
import 'package:pointify/screens/authentication/landing.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/utils/colors.dart';
import 'package:get/get.dart';
import 'controllers/AuthController.dart';
import 'controllers/realm_controller.dart';

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

final AuthController appController = Get.put(AuthController());
final RealmController realmServices = Get.put(RealmController());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String appId = 'application-0-iosyj';
  appController.initialize(appId);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  UserController attendantController =
      Get.put<UserController>(UserController());
  PlanController planController = Get.put<PlanController>(PlanController());
  HomeController homeController = Get.put<HomeController>(HomeController());
  final RealmController realmService = Get.put(RealmController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, c) {
          return GetMaterialApp(
            title: 'Pointify:',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: AppColors.mainColor,
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory),
            initialBinding: AuthBinding(),
            // home: FutureBuilder(
            //     future: authController.getUserType(),
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       // if (snapshot.connectionState == ConnectionState.waiting) {
            //       //   return const Center(child: CircularProgressIndicator());
            //       // }
            //       if (snapshot.hasError) {
            //         return Landing();
            //       }
            //       if (snapshot.hasData) {
            //         if (snapshot.data[0] == "admin") {
            //           AdminModel userModel = snapshot.data[1];
            //           if (userModel.shops!.isEmpty) {
            //             return CreateShop(
            //               page: "home",
            //             );
            //           } else {
            //             return Home();
            //           }
            //         }
            //
            //         return AttendantLanding();
            //       } else {
            //         return Landing();
            //       }
            //     }),
            home: Authenticate(),
          );
        });
  }
}

class Authenticate extends StatelessWidget {
  Authenticate({Key? key}) : super(key: key);

  _auth() {
    if (realmServices.currentUser!.value != null) {
      var shop = RShop().getShop();
      if (shop.isEmpty) {
        return CreateShop(page: "home");
      } else {
        return Home();
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
