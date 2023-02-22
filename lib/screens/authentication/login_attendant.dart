// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/themer.dart';
import '../../widgets/header.dart';

class AttendantLogin extends StatelessWidget {
  AttendantLogin({Key? key}) : super(key: key);
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios))),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
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
            Form(
                key: authController.loginAttendantKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Container(
                        child: TextFormField(
                          controller: authController.attendantUidController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your userid';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: ThemeHelper().textInputDecoration(
                              'UserId', 'Enter your UserID'),
                        ),
                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: TextFormField(
                          controller:
                              authController.attendantPasswordController,
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
                      SizedBox(height: 25.0),
                      Obx(() {
                        return authController.LoginAttendantLoad.value
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    authController.loginAttendant(context);
                                  },
                                ),
                              );
                      }),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
