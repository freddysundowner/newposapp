import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/authentication/landing.dart';
import 'package:get/get.dart';
import 'package:pointify/widgets/alert.dart';

import '../../../controllers/AuthController.dart';
import '../../../utils/colors.dart';
import '../../../utils/themer.dart';
import '../../../widgets/header.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                ))),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/logo2.png",
                    width: 250,
                  ),
                  const Text("An enterprise at your fingertips."),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              isSmallScreen(context)
                  ? Column(
                      children: [
                        _title(),
                        const SizedBox(height: 30.0),
                        loginForm(context),
                      ],
                    )
                  : Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0), //(x,y)
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.25,
                        right: MediaQuery.of(context).size.width * 0.25,
                      ),
                      child: Column(
                        children: [
                          _title(),
                          const SizedBox(height: 30.0),
                          loginForm(context),
                        ],
                      )),
            ],
          ),
        ));
  }

  Padding _title() {
    return const Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Text(
        'Forgot password',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget loginForm(context) {
    return Form(
        key: authController.adminresetPassWordFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Container(
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                child: TextFormField(
                  controller: authController.emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: isSmallScreen(context)
                      ? ThemeHelper()
                          .textInputDecoration('Email', 'Enter your email')
                      : ThemeHelper().textInputDecorationDesktop(
                          'Email', 'Enter your email'),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                child: TextFormField(
                  controller: authController.passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: isSmallScreen(context)
                      ? ThemeHelper().textInputDecoration(
                          'new password', 'Enter your new password')
                      : ThemeHelper().textInputDecorationDesktop(
                          'new password', 'Enter your new password'),
                ),
              ),
              const SizedBox(height: 15.0),
              Container(
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                child: TextFormField(
                  controller: authController.passwordControllerConfirm,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm password';
                    }
                    if (value != authController.passwordController.text) {
                      return "Password must match";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: isSmallScreen(context)
                      ? ThemeHelper().textInputDecoration(
                          'confirm password', 'Please confirm password')
                      : ThemeHelper().textInputDecorationDesktop(
                          'confirm password', 'Please confirm password'),
                ),
              ),
              const SizedBox(height: 15.0),
              Obx(() {
                return authController.loginuserLoad.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'Send'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (authController
                              .adminresetPassWordFormKey.currentState!
                              .validate()) {
                            authController.resetPasswordEmail(
                                authController.emailController.text,
                                authController.passwordController.text);
                          }
                        },
                      );
              }),
            ],
          ),
        ));
  }
}
