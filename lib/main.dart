import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pointify/bindings.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/models/admin_model.dart';
import 'package:pointify/screens/attendant/attendant_landing.dart';
import 'package:pointify/screens/home/home.dart';
import 'package:pointify/screens/authentication/landing.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/utils/colors.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  AttendantController attendantController =
      Get.put<AttendantController>(AttendantController());
  PlanController planController = Get.put<PlanController>(PlanController());
  AuthController authController = Get.put<AuthController>(AuthController());
  HomeController homeController = Get.put<HomeController>(HomeController());

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
            home: FutureBuilder(
                future: authController.getUserType(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Landing();
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data[0] == "admin") {
                      AdminModel userModel = snapshot.data[1];
                      if (userModel.shops!.isEmpty) {
                        return CreateShop(
                          page: "home",
                        );
                      } else {
                        return Home();
                      }
                    }

                    return AttendantLanding();
                  } else {
                    return Landing();
                  }
                }),
          );
        });
  }
}
