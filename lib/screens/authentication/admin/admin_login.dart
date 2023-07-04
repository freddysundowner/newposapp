import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/authentication/admin/forgot_password.dart';
import 'package:pointify/screens/authentication/admin/sign_up.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/themer.dart';
import '../../../widgets/header.dart';

class AdminLogin extends StatelessWidget {
  AdminLogin({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  HomeController homeController = Get.find<HomeController>();
  final AuthController appController = Get.find<AuthController>();
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
              icon: Icon(
                Icons.clear,
                color: Colors.black,
              ))),
      body: ResponsiveWidget(
          largeScreen: Align(
            alignment: Alignment.center,
            child: Container(
              width: 400,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.0),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 0.0), //(x,y)
                    blurRadius: 1.0,
                  ),
                ],
              ),
              child: loginForm(context),
            ),
          ),
          smallScreen: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/logo2.png",
                      width: 250,
                    ),
                    Text("An enterprise at your fingertips."),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                loginForm(context),
              ],
            ),
          )),
    );
  }

  Padding _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        'Login as an admin',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget loginForm(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _title(),
        const SizedBox(
          height: 20,
        ),
        Form(
            key: authController.loginKey,
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
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: authController.passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: isSmallScreen(context)
                          ? ThemeHelper().textInputDecoration(
                              'Password', 'Enter your password')
                          : ThemeHelper().textInputDecorationDesktop(
                              'Password', 'Enter your password'),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => ForgotPassword());
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mainColor,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Obx(() {
                    return authController.loginuserLoad.value
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                'Sign In'.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              authController.login(context);
                            },
                          );
                  }),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Don\'t have an account? "),
                      TextSpan(
                        text: 'Create',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(SignUp());
                          },
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ])),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
