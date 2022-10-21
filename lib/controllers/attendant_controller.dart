import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/attendant.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class AttendantController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  RxBool creatingAttendantsLoad = RxBool(false);

  saveAttendant({required shopId}) async {
    String name = nameController.text;
    String password = passwordController.text;
    if (name == "" || password == "") {
      showSnackBar(message: "please fill all the fields", color: Colors.red);
    } else {
      try {
        creatingAttendantsLoad.value = true;
        Map<String, dynamic> body = {
          "fullnames": nameController.text,
          "shops": shopId,
          "roles": [],
          "password": passwordController.text,
        };

        var response = await Attendant().createAttendant(body: body);
        clearTextFields();
        Get.back();
        showSnackBar(message: response["message"], color: AppColors.mainColor);

        creatingAttendantsLoad.value = false;
      } catch (e) {
        creatingAttendantsLoad.value = false;
      }
    }
  }

  clearTextFields() {
    nameController.text = "";
    passwordController.text = "";
  }
}
