import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../screens/home/home.dart';
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
  RxBool updateShopLoad = RxBool(false);
  RxBool deleteShopLoad = RxBool(false);
  Rxn<ShopModel> currentShop = Rxn(null);
  RxList<ShopModel> AdminShops = RxList([]);

  createShop({required page,required context}) async {
    if (nameController.text == "" ||
        businessController.text == "" ||
        reqionController.text == "") {
      showSnackBar(message: "please enter all fields", color: Colors.red,context: context);
    } else if (terms.value == false) {
      showSnackBar(
          message: "Accept terms and conditons to continue", color: Colors.red,context: context);
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
          showSnackBar(message: response["message"], color: Colors.red,context: context);
        } else {
          clearTextFields();
          await getShopsByAdminId(adminId: userId);
          if (page == "home") {
            await Get.find<AuthController>().getUserById();
            Get.off(() => Home());
          } else {
            Get.back();
          }
          showSnackBar(message: response["message"], color: Colors.red,context: context);
        }

        createShopLoad.value = false;
      } catch (e) {
        createShopLoad.value = false;
      }
    }
  }

  getShopsByAdminId({required adminId,String? name}) async {
    try {
      AdminShops.clear();
      gettingShopsLoad.value = true;
      var response = await Shop().getShopsByAdminId(adminId: adminId,name:name);

      if (response != null) {
        List shops = response["body"];
        List<ShopModel> shopsData = shops.map((e) => ShopModel.fromJson(e)).toList();
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

  initializeControllers({required ShopModel shopModel}) {
    nameController.text = shopModel.name.toString();
    businessController.text = shopModel.type.toString();
    reqionController.text = shopModel.location.toString();
    currency.value = shopModel.currency!;
  }

  updateShop({required id, required adminId,required context}) async {
    try {
      updateShopLoad.value = true;
      Map<String, dynamic> body = {
        if (nameController.text != "") "name": nameController.text,
        if (reqionController.text != "") "location": reqionController.text,
        if (businessController.text != "") "type": businessController.text,
        "currency":
            currency.value == "" ? Constants.currenciesData[0] : currency.value,
      };
      var response = await Shop().updateShops(id: id, body: body);
      getShopsByAdminId(adminId: adminId);
      Get.back();
      showSnackBar(message: response["message"], color: AppColors.mainColor,context: context);

      updateShopLoad.value = false;
    } catch (e) {
      updateShopLoad.value = false;
    }
  }

  deleteShop({required id, required adminId,required context}) async {
    try {
      deleteShopLoad.value = true;
      var response = await Shop().deleteShop(id: id);
      getShopsByAdminId(adminId: adminId);
      Get.back();
      showSnackBar(message: response["message"], color: AppColors.mainColor,context: context);

      deleteShopLoad.value = false;
    } catch (e) {
      deleteShopLoad.value = false;
    }
  }

}
