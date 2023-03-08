import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/roles_model.dart';
import 'package:flutterpos/widgets/loading_dialog.dart';
import 'package:get/get.dart';

import '../services/attendant.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';
import 'AuthController.dart';

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

  saveAttendant({required shopId, required context}) async {
    String name = nameController.text;
    String password = passwordController.text;
    if (name == "" || password == "") {
      showSnackBar(
          message: "please fill all the fields",
          color: Colors.red,
          context: context);
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
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);

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
      List att = [
        {
          "_id": "63fda3fed13cf778aab94e2f",
          "fullnames": "kimani",
          "attendid": 89107,
          "phonenumber": null,
          "shop": {
            "_id": "63fa089e46721b7480474be5",
            "name": "apple",
            "location": "nakuru",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "electronics",
            "currency": "ARS",
            "createdAt": "2023-02-25T13:09:50.801Z",
            "updatedAt": "2023-02-27T10:53:46.012Z",
            "__v": 0
          },
          "password": "kimani89",
          "roles": [
            {"key": "sales", "value": "sales"},
            {"key": "stockin", "value": "Stockin "},
            {"key": "discounts", "value": "Discount"},
            {"key": "add_products", "value": "Add products"},
            {"key": "expenses", "value": "Add expenses"},
            {"key": "customers", "value": "Manage Customers"},
            {"key": "Suppliers", "value": "Manage suppliers"},
            {"key": "stock_balance", "value": "Stock balance"},
            {"key": "count_stock", "value": "Count stock"},
            {"key": "edit_entries", "value": "Edit entries"}
          ],
          "createdAt": "2023-02-28T06:49:34.652Z",
          "updatedAt": "2023-03-01T12:42:14.026Z",
          "__v": 0
        },
        {
          "_id": "63fc8c598e7d4a3bbf4893a6",
          "fullnames": "kimani",
          "attendid": 27158,
          "phonenumber": null,
          "shop": {
            "_id": "63fa089e46721b7480474be5",
            "name": "apple",
            "location": "nakuru",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "electronics",
            "currency": "ARS",
            "createdAt": "2023-02-25T13:09:50.801Z",
            "updatedAt": "2023-02-27T10:53:46.012Z",
            "__v": 0
          },
          "password": "kimani89",
          "roles": [
            {"key": "sales", "value": "sales"},
            {"key": "stockin", "value": "Stockin "},
            {"key": "discounts", "value": "Discount"},
            {"key": "add_products", "value": "Add products"}
          ],
          "createdAt": "2023-02-27T10:56:25.666Z",
          "updatedAt": "2023-02-27T10:56:25.666Z",
          "__v": 0
        },
        {
          "_id": "63fc75a28e7d4a3bbf488e9a",
          "fullnames": "petero",
          "attendid": 28894,
          "phonenumber": null,
          "shop": {
            "_id": "63fa089e46721b7480474be5",
            "name": "apple",
            "location": "nakuru",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "electronics",
            "currency": "ARS",
            "createdAt": "2023-02-25T13:09:50.801Z",
            "updatedAt": "2023-02-27T10:53:46.012Z",
            "__v": 0
          },
          "password": "kimai89",
          "roles": [],
          "createdAt": "2023-02-27T09:19:30.083Z",
          "updatedAt": "2023-02-27T09:19:30.083Z",
          "__v": 0
        },
        {
          "_id": "63fc75a28e7d4a3bbf488e9a",
          "fullnames": "petero",
          "attendid": 28894,
          "phonenumber": null,
          "shop": {
            "_id": "63fa089e46721b7480474be5",
            "name": "apple",
            "location": "nakuru",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "electronics",
            "currency": "ARS",
            "createdAt": "2023-02-25T13:09:50.801Z",
            "updatedAt": "2023-02-27T10:53:46.012Z",
            "__v": 0
          },
          "password": "kimai89",
          "roles": [],
          "createdAt": "2023-02-27T09:19:30.083Z",
          "updatedAt": "2023-02-27T09:19:30.083Z",
          "__v": 0
        },
        {
          "_id": "63fc75a28e7d4a3bbf488e9a",
          "fullnames": "petero",
          "attendid": 28894,
          "phonenumber": null,
          "shop": {
            "_id": "63fa089e46721b7480474be5",
            "name": "apple",
            "location": "nakuru",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "electronics",
            "currency": "ARS",
            "createdAt": "2023-02-25T13:09:50.801Z",
            "updatedAt": "2023-02-27T10:53:46.012Z",
            "__v": 0
          },
          "password": "kimai89",
          "roles": [],
          "createdAt": "2023-02-27T09:19:30.083Z",
          "updatedAt": "2023-02-27T09:19:30.083Z",
          "__v": 0
        }
      ];
      List attendantsData = att;
      List<AttendantModel> attendantList =
          attendantsData.map((e) => AttendantModel.fromJson(e)).toList();

      attendants.assignAll(attendantList);
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
      getAttendantByIdLoad.value = false;
      if (response == null) {
        attendant.value = AttendantModel();
        Get.find<AuthController>().logout();
      }
      AttendantModel userModel = AttendantModel.fromJson(response["body"]);
      attendant.value = userModel;
      Get.find<ShopController>().currentShop.value = userModel.shop;
      return userModel;
    } catch (e) {
      var data = {
        "_id": "63fc8c598e7d4a3bbf4893a6",
        "fullnames": "kimani",
        "attendid": 27158,
        "phonenumber": null,
        "shop": {
          "_id": "63fa089e46721b7480474be5",
          "name": "apple",
          "location": "nakuru",
          "owner": "63f9efe3879e16801054a0b0",
          "type": "electronics",
          "currency": "ARS",
          "createdAt": "2023-02-25T13:09:50.801Z",
          "updatedAt": "2023-02-27T10:53:46.012Z",
          "__v": 0
        },
        "password": "abhsbh",
        "roles": [
          {"key": "sales", "value": "sales"},
          {"key": "stockin", "value": "Stockin "},
          {"key": "discounts", "value": "Discount"},
          {"key": "add_products", "value": "Add products"}
        ],
        "createdAt": "2023-02-27T10:56:25.666Z",
        "updatedAt": "2023-02-27T10:56:25.666Z",
        "__v": 0
      };
      AttendantModel userModel = AttendantModel.fromJson(data);
      attendant.value = userModel;
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
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
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
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  updateAttedant({required id, required rolesData}) async {
    try {
      creatingAttendantsLoad.value = true;
      Map<String, dynamic> body = {
        "fullnames": nameController.text,
        "roles": rolesData.map((element) => element.toJson()).toList(),
      };

      var response = await Attendant().updateAttendant(id: id, body: body);
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
    }
  }

  checkRole(String key) {
    return attendant.value!.roles!
            .indexWhere((element) => element.key == key) !=
        -1;
  }
}
