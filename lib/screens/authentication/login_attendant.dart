// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../utils/themer.dart';
import '../../widgets/header.dart';

class AttendantLogin extends StatelessWidget {
  AttendantLogin({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: MediaQuery.of(context).size.width <= 600
              ? AppColors.mainColor
              : Colors.white,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.clear,
                color: MediaQuery.of(context).size.width <= 600
                    ? Colors.white
                    : Colors.black,
              ))),
      backgroundColor: Colors.white,
      body: ResponsiveWidget(
          largeScreen: Align(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      'Login As Cashier',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  loginAttendant(context),
                ],
              ),
            ),
          ),
          smallScreen: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: Header(200, true,
                      "assets/images/worker.svg"), //let's create a common header widget
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'Login As Cashier',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30.0),
                loginAttendant(context),
              ],
            ),
          )),
    );
  }

  Widget loginAttendant(context) {
    return Form(
        key: authController.loginAttendantKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Container(
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                child: TextFormField(
                  controller: authController.attendantUidController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your userid';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: ResponsiveWidget.isSmallScreen(context)
                      ? ThemeHelper()
                          .textInputDecoration('User Id', 'Enter your UserID')
                      : ThemeHelper().textInputDecorationDesktop(
                          'UserId', 'Enter your UserID'),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                child: TextFormField(
                  controller: authController.attendantPasswordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: ResponsiveWidget.isSmallScreen(context)
                      ? ThemeHelper().textInputDecoration(
                          'Password', 'Enter your password')
                      : ThemeHelper().textInputDecorationDesktop(
                          'Password', 'Enter your password'),
                ),
              ),
              SizedBox(height: 25.0),
              Obx(() {
                return authController.LoginAttendantLoad.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              'Next'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            authController.attendantLogin(context);
                          },
                        ),
                      );
              }),
            ],
          ),
        ));
  }
}
