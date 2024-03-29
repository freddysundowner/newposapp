import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/home.dart';
import 'package:realm/realm.dart';

import '../../Real/schema.dart';
import '../../controllers/realm_controller.dart';
import '../../controllers/user_controller.dart';
import '../../services/users.dart';
import '../../utils/colors.dart';
import '../home/home_page.dart';

class ReloadPage extends StatefulWidget {
  const ReloadPage({Key? key}) : super(key: key);

  @override
  State<ReloadPage> createState() => _ReloadPageState();
}

class _ReloadPageState extends State<ReloadPage> {
  UserController userController = Get.put(UserController());
  final RealmController realmServices = Get.put(RealmController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    countDownTimer();
    // _auth();
  }

  int countDown = 0;

  countDownTimer() async {
    for (int x = 5; x > 0; x--) {
      await Future.delayed(const Duration(seconds: 1)).then((_) {
        setState(() {
          countDown = x;
        });
        if (x == 1) {
          userController.getUser();

          isSmallScreen(context)
              ? Get.to(() => Scaffold(
                    body: SafeArea(
                      child: HomePage(),
                    ),
                  ))
              : Get.to(() => Scaffold(
                    body: SafeArea(
                      child: Home(),
                    ),
                  ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () {
          userController.getUser();
          isSmallScreen(context)
              ? Get.to(() => Scaffold(
                    body: SafeArea(
                      child: HomePage(),
                    ),
                  ))
              : Get.to(() => Scaffold(
                    body: SafeArea(
                      child: Home(),
                    ),
                  ));
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child:
                    Icon(Icons.refresh, size: 120, color: AppColors.mainColor),
                onTap: () {
                  Get.to(() => Scaffold(
                        body: SafeArea(
                          child: Home(),
                        ),
                      ));
                  Get.find<HomeController>().selectedWidget.value = Home();
                },
              ),
              Text(
                "Initializing please wait... $countDown",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
