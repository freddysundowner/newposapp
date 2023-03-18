import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/authentication/sign_up.dart';
import 'package:flutterpos/screens/home/home.dart';
import 'package:flutterpos/screens/home/home_page.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/themer.dart';
import '../../widgets/header.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: MediaQuery.of(context).size.width<=600
                  ? AppColors.mainColor
                  : Colors.white,
              elevation: 0.0,
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color:MediaQuery.of(context).size.width<=600
                        ?Colors.white
                        : Colors.black,
                  ))),
          body: ResponsiveWidget(
              largeScreen: Align(
                alignment: Alignment.center,
                child: Container(

                  child: Container(
                    width: 400,
                    height: MediaQuery.of(context).size.height * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1.0),
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
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            'Login As Admin',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        loginForm(context),
                      ],
                    ),
                  ),
                ),
              ),
              smallScreen: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      child: Header(200, true,
                          "assets/images/admin.svg"), //let's create a common header widget
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Login As Admin',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30.0),
                    loginForm(context),
                  ],
                ),
              )),
        );
  }

  Widget loginForm(context) {

      return Form(
          key: authController.loginKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: authController.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: ResponsiveWidget.isSmallScreen(context)
                        ? ThemeHelper()
                            .textInputDecoration('Email', 'Enter your email')
                        : ThemeHelper().textInputDecorationDesktop(
                            'Email', 'Enter your email'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(height: 20.0),
                Container(
                  child: TextFormField(
                    controller: authController.passwordController,
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
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
                SizedBox(height: 15.0),
                Obx(() {
                  return authController.loginuserLoad.value
                      ? Center(
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    ),
                  ])),
                ),
              ],
            ),
          ));

  }
}
