import 'package:flutter/material.dart';
import 'package:flutterpos/bindings.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/models/admin_model.dart';
import 'package:flutterpos/screens/attendant/attendant_landing.dart';
import 'package:flutterpos/screens/home/home.dart';
import 'package:flutterpos/screens/landing/landing.dart';
import 'package:flutterpos/screens/shop/create_shop.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  AuthController authController = Get.put<AuthController>(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.mainColor,
      ),
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
            return Container();
          }),
    );
  }
}
