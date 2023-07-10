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
        backgroundColor: Colors.white,
        body: ListView(
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
            const SizedBox(height: 40),
            isSmallScreen(context)
                ? signUpForm(context)
                : Container(
                padding: const EdgeInsets.only(top: 10),
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
                child: signUpForm(context))
          ],
        ));
  }

  Widget signUpForm(context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            "Create Your Account",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
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
                    decoration: isSmallScreen(context)
                        ? ThemeHelper().textInputDecoration(
                        'Username*', 'Enter your username')
                        : ThemeHelper().textInputDecorationDesktop(
                        'Username*', 'Enter your username'),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  child: TextFormField(
                    controller: authController.emailController,
                    decoration: isSmallScreen(context)
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
                const SizedBox(height: 20.0),
                Container(
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  child: TextFormField(
                    controller: authController.phoneController,
                    decoration: isSmallScreen(context)
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
                    decoration: isSmallScreen(context)
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
                const SizedBox(height: 20.0),
                Obx(
                      () => authController.signuserLoad.value
                      ? const Center(
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
