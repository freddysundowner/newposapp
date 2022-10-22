import 'package:flutter/material.dart';
import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/roles_model.dart';
import 'package:get/get.dart';

import '../services/attendant.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class AttendantController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  RxBool creatingAttendantsLoad = RxBool(false);
  RxBool getAttendantsLoad = RxBool(false);
  RxList<AttendantModel> attendants = RxList([]);
  RxList<RolesModel> roles = RxList([]);
  RxList<RolesModel> rolesFromApi = RxList([]);

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
          "shop": shopId,
          "roles": roles.map((element) => element.toJson()).toList(),
          "password": passwordController.text,
        };

        var response = await Attendant().createAttendant(body: body);
        clearTextFields();
        getAttendantsByShopId(shopId: shopId);
        Get.back();
        showSnackBar(message: response["message"], color: AppColors.mainColor);

        creatingAttendantsLoad.value = false;
      } catch (e) {
        creatingAttendantsLoad.value = false;
      }
    }
  }

  getAttendantRoles() async {
    try {
      var response = await Attendant().getRoles();
      rolesFromApi.clear();
      if (response != null) {
        List fetchedRoles = response["body"][0]["roles"];
        List<RolesModel> role =
            fetchedRoles.map((e) => RolesModel.fromJson(e)).toList();
        rolesFromApi.assignAll(role);
      } else {
        rolesFromApi.value = [];
      }
    } catch (e) {}
  }

  getAttendantsByShopId({required shopId}) async {
    try {
      getAttendantsLoad.value = true;
      var response = await Attendant().getAttendantsById(shopId);
      if (response != null) {
        List attendantsData = response["body"];
        print(attendantsData);
        List<AttendantModel> attendantList =
            attendantsData.map((e) => AttendantModel.fromJson(e)).toList();
        print("hello ${attendantList}");
        attendants.assignAll(attendantList);
      } else {
        attendants.value = [];
      }
      getAttendantsLoad.value = false;
    } catch (e) {
      getAttendantsLoad.value = false;
    }
  }

  clearTextFields() {
    nameController.text = "";
    passwordController.text = "";
  }
}
