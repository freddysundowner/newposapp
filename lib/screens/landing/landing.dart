import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors.dart';
import '../authentication/login.dart';

class Landing extends StatelessWidget {
   Landing({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                color: AppColors.mainColor,
                height: MediaQuery.of(context).size.height / 3,
              ),
              Positioned(
                bottom: -100,
                right: 5,
                child: Container(
                  child: SvgPicture.asset(
                    "assets/images/finance.svg",
                    height: 200,
                    width: 200,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reggy",
                  style: GoogleFonts.fredokaOne(
                      fontSize: 40, color: AppColors.mainColor),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "An enterprise at your fingertips.",
                  style: GoogleFonts.sofia(
                    fontSize: 19,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  "Login as",
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700, fontSize: 21),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: GestureDetector(
                    onTap: () {
                      // Get.to(AttendantLoginPage());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainColor, width: 2),
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Cashier".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            )
                          ]),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(Login());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.mainColor, width: 2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: AppColors.mainColor,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Admin".toUpperCase(),
                              style: TextStyle(
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17),
                            )
                          ]),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}