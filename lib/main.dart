import 'package:flutter/material.dart';
import 'package:flutterpos/bindings.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/screens/authentication/login.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:get/get.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
AuthController authController=Get.put<AuthController>(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Pos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.mainColor,
      ),
      initialBinding: AuthBinding(),
      home:Login(),
    );
  }
}

