import 'package:flutter/material.dart';
import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/roles_model.dart';
import 'package:flutterpos/widgets/loading_dialog.dart';
import 'package:get/get.dart';

import '../services/attendant.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class AttendantController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  RxBool creatingAttendantsLoad = RxBool(false);
  RxBool getAttendantsLoad = RxBool(false);
  RxBool getAttendantByIdLoad = RxBool(false);
  RxList<AttendantModel> attendants = RxList([]);
  Rxn<AttendantModel> attendant = Rxn(null);
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
      var response = await Attendant().getAttendantsByShopId(shopId);
      if (response != null) {
        List attendantsData = response["body"];
        List<AttendantModel> attendantList =
            attendantsData.map((e) => AttendantModel.fromJson(e)).toList();

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

  getAttendantsById(id) async {
    try {
      getAttendantByIdLoad.value = true;
      var response = await Attendant().getAttendantById(id);
      if (response != null) {
        attendant.value = AttendantModel.fromJson(response["body"]);
      } else {
        attendant.value = AttendantModel();
      }
      getAttendantByIdLoad.value = false;
    } catch (e) {
      getAttendantByIdLoad.value = false;
    }
  }

  updatePassword({required id, required BuildContext context}) async {
    try {
      Map<String, dynamic> body = {"password": passwordController.text};
      LoadingDialog.showLoadingDialog(
          context: context,
          title: "Updating password please wait...",
          key: _keyLoader);
      var response = await Attendant().updatePassword(id, body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  deleteAttendant(
      {required id, required BuildContext context, required shopId}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context,
          title: "Deleting attendant please wait...",
          key: _keyLoader);
      var response = await Attendant().deleteAttendant(id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        Get.back();
        getAttendantsByShopId(shopId: shopId);
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  updateAttedant({required id,required rolesData}) async {
    try {
      creatingAttendantsLoad.value = true;
      Map<String, dynamic> body = {
        "fullnames": nameController.text,
        "roles": rolesData.map((element) => element.toJson()).toList(),
      };
      print(body);
      var response = await Attendant().updateAttendant(id: id, body: body);
      print(response);
      if (response != null) {
        int index = attendants.indexWhere((element) => element.id == id);
        if (index != -1) {
          attendants[index] = AttendantModel.fromJson(response);
          attendants.refresh();
        }
        Get.back();
      }
      creatingAttendantsLoad.value = false;
    } catch (e) {
      creatingAttendantsLoad.value = false;
      print(e);
    }
  }
}
