import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/models/shop_category.dart';
import 'package:pointify/models/shop_model.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/home/shops_page.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/utils/constants.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/home/home.dart';
import '../services/shop.dart';
import 'AuthController.dart';

class ShopController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController reqionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxString currency = RxString("");
  Rxn<ShopCategory> selectedCategory = Rxn(null);
  RxBool terms = RxBool(false);
  RxBool createShopLoad = RxBool(false);
  RxBool gettingShopsLoad = RxBool(false);
  RxBool updateShopLoad = RxBool(false);
  RxBool loadingcateries = RxBool(false);
  RxBool deleteShopLoad = RxBool(false);
  Rxn<ShopModel> currentShop = Rxn(null);
  RxList<ShopModel> allShops = RxList([]);
  RxList<ShopCategory> categories = RxList([]);

  createShop({required page, required context}) async {
    if (nameController.text == "" ||
        selectedCategory.value == null ||
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
          "category": selectedCategory.value!.id,
          "currency": currency.value == ""
              ? Constants.currenciesData[0]
              : currency.value,
        };

        var response = await Shop().createShop(body: body);
        await setDefaulShop(ShopModel.fromJson(response["body"]));
        if (response["status"] == false) {
          showSnackBar(message: response["message"], color: Colors.red);
        } else {
          clearTextFields();
          await getShops(adminId: userId);
          if (MediaQuery.of(context).size.width > 600) {
            if (page == "home") {
              Get.find<HomeController>().selectedWidget.value = HomePage();
            } else {
              Get.find<HomeController>().selectedWidget.value = ShopsPage();
            }
          } else if (page == "home") {
            await Get.find<AuthController>().getUserById();
            Get.off(() => Home());
          } else {
            Get.back();
          }
        }

        createShopLoad.value = false;
      } catch (e) {
        createShopLoad.value = false;
      }
    }
  }

  getShops({required adminId, String? name}) async {
    try {
      gettingShopsLoad.value = true;

      var response = await Shop().getShops(adminId: adminId, name: name);
      if (response != null) {
        List shops = response["body"];
        List<ShopModel> shopsData =
            shops.map((e) => ShopModel.fromJson(e)).toList();
        allShops.assignAll(shopsData);
      } else {
        allShops.value = [];
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
    selectedCategory.value = shopModel.category;
    refresh();
    reqionController.text = shopModel.location.toString();
    currency.value = shopModel.currency!;
  }

  Future<String?> setDefaulShop(ShopModel shopBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("current_shop", shopBody.id!);
    currentShop.value = shopBody;
    await Get.find<SalesController>().getSales(onCredit: "");
    ;
  }

  getDefaultShop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var shop = prefs.getString("current_shop");
    if (shop != null) {
      var response = await Shop().getShopById(id: shop);
      if (response["body"] == null) {
        if (Get.find<AuthController>().usertype.value == "attendant") {
          Get.find<AuthController>().logout();
        }
        Get.to(() => CreateShop(page: "home"));
      }
      currentShop.value = ShopModel.fromJson(response["body"]);
      currentShop.refresh();
    } else {
      String? userId = Get.find<AuthController>().currentUser.value?.id;
      await getShops(adminId: userId);
      currentShop.value = allShops.isNotEmpty ? allShops.first : null;
    }
  }

  updateShop({required adminId, required shopId}) async {
    try {
      updateShopLoad.value = true;
      Map<String, dynamic> body = {
        if (nameController.text != "") "name": nameController.text,
        if (reqionController.text != "") "location": reqionController.text,
        if (currentShop.value?.category != null)
          "category": currentShop.value?.category?.id,
        "currency":
            currency.value == "" ? Constants.currenciesData[0] : currency.value,
      };
      var response = await Shop().updateShops(shopId: shopId, body: body);
      if (response["status"] == true) {
        if (MediaQuery.of(Get.context!).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = ShopsPage();
        } else {
          Get.back();
        }
        getShops(adminId: adminId);
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
      }

      updateShopLoad.value = false;
    } catch (e) {
      updateShopLoad.value = false;
    }
  }

  deleteShop({required id, required adminId, required context}) async {
    try {
      deleteShopLoad.value = true;
      var response = await Shop().deleteShop(id: id);
      if (response["status"] == true) {
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = ShopsPage();
        } else {
          Get.back();
        }
        getShops(adminId: adminId);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
      deleteShopLoad.value = false;
    } catch (e) {
      deleteShopLoad.value = false;
    }
  }

  getCategories() async {
    try {
      categories.clear();
      loadingcateries.value = true;
      var response = await Shop.getCategories();
      List list = response["reponse"];
      print(list);
      categories.value = list.map((e) => ShopCategory.fromJson(e)).toList();
      loadingcateries.value = false;
    } catch (e) {
      print(e);
      loadingcateries.value = false;
    }
  }
}
