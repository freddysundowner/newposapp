import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/screens/authentication/sign_up.dart';
import 'package:get/get.dart';

import '../../utils/themer.dart';
import '../../widgets/header.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios))),
      body: SingleChildScrollView(
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30.0),
            Form(
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
                          decoration: ThemeHelper()
                              .textInputDecoration('Email', 'Enter your email'),
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
                          decoration: ThemeHelper().textInputDecoration(
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
                )),
          ],
        ),
      ),
    );
  }
}
