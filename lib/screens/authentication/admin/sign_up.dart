import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/utils/colors.dart';
import 'package:get/get.dart';

import '../../../controllers/AuthController.dart';
import '../../../utils/themer.dart';
import '../../../widgets/header.dart';

class SignUp extends StatelessWidget {
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
                Icons.arrow_back_ios,
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
                  SizedBox(
                    height: 20,
                  ),
                  signUpForm(context),
                ],
              ),
            ),
          ),
          smallScreen: ListView(
            children: [
              Container(
                height: 100,
                child: Header(200, true, "assets/images/team.svg"),
              ),
              SizedBox(height: 40),
              signUpForm(context)
            ],
          )),
    );
  }

  Widget signUpForm(context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            "Create Your Account",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Form(
            key: authController.signupkey,
            child: Column(
              children: [
                Container(
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  child: TextFormField(
                    controller: authController.nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: ResponsiveWidget.isSmallScreen(context)
                        ? ThemeHelper().textInputDecoration(
                            'Username*', 'Enter your username')
                        : ThemeHelper().textInputDecorationDesktop(
                            'Username*', 'Enter your username'),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  child: TextFormField(
                    controller: authController.emailController,
                    decoration: ResponsiveWidget.isSmallScreen(context)
                        ? ThemeHelper().textInputDecoration(
                            "E-mail address*", "Enter your email")
                        : ThemeHelper().textInputDecorationDesktop(
                            "E-mail address*", "Enter your email"),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  child: TextFormField(
                    controller: authController.phoneController,
                    decoration: ResponsiveWidget.isSmallScreen(context)
                        ? ThemeHelper().textInputDecoration(
                            "Mobile Number*", "Enter your mobile number")
                        : ThemeHelper().textInputDecorationDesktop(
                            "Mobile Number*", "Enter your mobile number"),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  child: TextFormField(
                    controller: authController.passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: ResponsiveWidget.isSmallScreen(context)
                        ? ThemeHelper().textInputDecoration(
                            "Password*", "Enter your password")
                        : ThemeHelper().textInputDecorationDesktop(
                            "Password*", "Enter your password"),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Obx(
                  () => authController.signuserLoad.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Register".toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            authController.signUser(context);
                          },
                        ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
