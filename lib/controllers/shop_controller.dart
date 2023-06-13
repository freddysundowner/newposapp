import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/Real/services/r_shop.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/utils/constants.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../screens/home/home.dart';
import '../screens/home/home_page.dart';
import '../screens/shop/shops_page.dart';
import '../services/users.dart';
import '../utils/colors.dart';

class ShopController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController reqionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  RxString currency = RxString("");
  Rxn<ShopTypes> selectedCategory = Rxn(null);
  RxBool terms = RxBool(false);
  RxBool createShopLoad = RxBool(false);
  RxBool gettingShopsLoad = RxBool(false);
  RxBool updateShopLoad = RxBool(false);
  RxBool loadingcateries = RxBool(false);
  RxBool deleteShopLoad = RxBool(false);
  Rxn<Shop> currentShop = Rxn(null);
  RxList<Shop> allShops = RxList([]);
  RxList<ShopTypes> categories = RxList([]);

  createShop({required page, required context}) async {
    createShopLoad.value = true;
    final newItem = Shop(ObjectId(),
        name: nameController.text,
        location: reqionController.text,
        owner: appController.app.value!.currentUser!.id,
        currency:
            currency.isEmpty ? Constants.currenciesData[0] : currency.value);
    newItem.type = Get.find<ShopController>().selectedCategory.value;
    RShop().createShop(newItem);

    getShops();
    Get.find<UserController>().getUser();
    clearTextFields();
    if (MediaQuery.of(context).size.width > 600) {
      if (page == "home") {
        Get.find<HomeController>().selectedWidget.value = HomePage();
      } else {
        Get.find<HomeController>().selectedWidget.value = ShopsPage();
      }
    } else if (page == "home") {
      Get.off(() => Home());
    } else {
      Get.back();
    }

    createShopLoad.value = false;
  }

  getShops({String name = ""}) async {
    try {
      gettingShopsLoad.value = true;

      RealmResults<Shop> response = await RShop().getShop(name: name);
      if (response.isNotEmpty) {
        allShops.assignAll(response.map((e) => e).toList());
        // if (currentShop.value == null) {
        //   Get.find<RealmController>().setDefaulShop(allShops.first);
        // }
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

  initializeControllers({required Shop shopModel}) {
    nameController.text = shopModel.name.toString();
    selectedCategory.value = shopModel.type;
    refresh();
    reqionController.text = shopModel.location ?? "";
    currency.value = shopModel.currency ?? "";
  }

  updateShop({Shop? shop}) async {
    try {
      updateShopLoad.value = true;
      await RShop().updateItem(shop!,
          name: nameController.text,
          currency: currency.value == ""
              ? Constants.currenciesData[0]
              : currency.value,
          type: Get.find<ShopController>().selectedCategory.value,
          location: reqionController.text);
      getShops();
      refresh();
      Get.back();
      showSnackBar(message: "shop updated", color: Colors.green);
      updateShopLoad.value = false;
    } catch (e) {
      updateShopLoad.value = false;
    }
  }

  deleteShop({required Shop shop, required context}) async {
    try {
      deleteShopLoad.value = true;
      var response = await RShop().deleteItem(shop);
      getShops();
      Get.back();
      showSnackBar(message: "shop deleted", color: AppColors.mainColor);
      deleteShopLoad.value = false;
    } catch (e) {
      deleteShopLoad.value = false;
    }
  }

  getCategories() async {
    try {
      loadingcateries.value = true;
      RealmResults<ShopTypes> response = RShop().getShopTypes();
      categories.value = response.map((e) => e).toList();
      loadingcateries.value = false;
    } catch (e) {
      loadingcateries.value = false;
    }
  }
}
