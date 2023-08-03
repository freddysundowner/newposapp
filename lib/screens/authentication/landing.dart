import 'package:flutter/material.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/authentication/admin/admin_login.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import 'attendant/login_attendant.dart';

class Landing extends StatelessWidget {
  Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        landingContent(),
        SizedBox(
          height: isSmallScreen(context) ? 100 : 50,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: InkWell(
            onTap: () {
              Get.to(AttendantLogin());
            },
            child: customButton(
                onTap: () {
                  Get.to(AttendantLogin());
                },
                color: AppColors.mainColor,
                title: "Cashier",
                textColor: Colors.white,
                icon: Icons.people_alt_outlined),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: InkWell(
            onTap: () {
              Get.to(AdminLogin());
            },
            child: customButton(
                onTap: () {
                  Get.to(AdminLogin());
                },
                color: Colors.white,
                title: "Admin",
                textColor: AppColors.mainColor,
                icon: Icons.person),
          ),
        ),
        Spacer(),
      ],
    ));
  }

  Widget landingImage() {
    return Container();
  }

  Widget landingContent() {
    return Column(
      children: [
        Image.asset(
          "assets/images/logo2.png",
          width: 250,
        ),
        Text("An enterprise at your fingertips."),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget customButton(
      {required onTap,
      required Color color,
      required title,
      required Color textColor,
      required icon}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onTap();
        },
        hoverColor: Colors.transparent,
        child: Center(
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: AppColors.mainColor, width: 2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: textColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "$title".toUpperCase(),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
