import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../services/shop.dart';
import 'AuthController.dart';

class ShopController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController reqionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxString currency = RxString("");
  RxBool terms = RxBool(false);
  RxBool createShopLoad = RxBool(false);
  RxBool gettingShopsLoad = RxBool(false);
  Rxn<ShopModel> currentShop = Rxn(null);
  RxList<ShopModel> AdminShops = RxList([]);

  createShop() async {
    if (nameController.text == "" ||
        businessController.text == "" ||
        reqionController.text == "") {
      showSnackBar(message: "please enter all fields", color: Colors.red);
    } else if (terms.value == false) {
      showSnackBar(
          message: "Accept terms and conditons to continue", color: Colors.red);
    } else {
      try {
        createShopLoad.value = true;
        String? userId = Get.find<AuthController>().currentUser.value?.id;
        Map<String, dynamic> body = {
          "name": nameController.text,
          "location": reqionController.text,
          "owner": userId,
          "type": businessController.text,
          "currency": currency.value == ""
              ? Constants.currenciesData[0]
              : currency.value,
        };

        var response = await Shop().createShop(body: body);

        if (response["status"] == false) {
          showSnackBar(message: response["message"], color: Colors.red);
        } else {
          clearTextFields();
          getShopsByAdminId(adminId: userId);
          Get.back();
          showSnackBar(message: response["message"], color: Colors.red);
        }

        createShopLoad.value = false;
      } catch (e) {
        createShopLoad.value = false;
      }
    }
  }

  getShopsByAdminId({required adminId}) async {
    try {
      AdminShops.clear();
      gettingShopsLoad.value = true;
      var response = await Shop().getShopsByAdminId(adminId: adminId);
      if (response != null) {
        List shops = response["body"];
        List<ShopModel> shopsData =
            shops.map((e) => ShopModel.fromJson(e)).toList();
        AdminShops.assignAll(shopsData);
      } else {
        AdminShops.value = [];
      }
      gettingShopsLoad.value = false;
    } catch (e) {
      gettingShopsLoad.value = false;
    }
  }

  clearTextFields() {
    nameController.text = "";
    businessController.text = "";
    reqionController.text = "";
    terms.value = false;
  }
}