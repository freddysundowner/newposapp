import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/shop/create_shop.dart';
import 'package:pointify/services/shop_services.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/utils/constants.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../screens/home/home.dart';
import '../screens/home/home_page.dart';
import '../screens/shop/shops_page.dart';
import '../services/users.dart';

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
  RxList excludefeatures = RxList(["usage", 'stock']);

  createShop({required page, required context}) async {
    if (nameController.text.trim().isEmpty) {
      generalAlert(title: "Error", message: "Please enter  name");
      return;
    }
    if (Get.find<ShopController>().selectedCategory.value==null) {
      generalAlert(title: "Error", message: "Please select business type");
      return;
    }
    if (reqionController.text.trim().isEmpty) {
      generalAlert(title: "Error", message: "Please enter location");
      return;
    }

    if (terms.isFalse) {
      generalAlert(title: "Error", message: "Accept terms and conditions");
      return;
    }
    createShopLoad.value = true;
    final newItem = Shop(ObjectId(),
        name: nameController.text,
        location: reqionController.text,
        subscriptiondate: DateTime.now().millisecondsSinceEpoch,
        owner: appController.app.value!.currentUser!.id,
        package:
            Get.find<PlanController>().plans.where((p0) => p0.price == 0).first,
        currency:
            currency.isEmpty ? Constants.currenciesData[0] : currency.value);
    newItem.type = Get.find<ShopController>().selectedCategory.value;
    ShopService().createShop(newItem);

    getShops();
    Get.find<UserController>().getUser();
    clearTextFields();
    if (!isSmallScreen(context)) {
      if (page == "home") {
        Get.off(() => Home());
      } else {
        Get.find<HomeController>().selectedWidget.value = ShopsPage();
        Get.find<HomeController>().activeItem.value = "Home";
      }
    } else if (page == "home") {
      Get.off(() => Home());
      Get.find<HomeController>().selectedWidget.value = HomePage();
    } else {
      Get.back();
    }

    createShopLoad.value = false;
  }

  getShops({String name = ""}) async {
    try {
      gettingShopsLoad.value = true;
      allShops.clear();
      RealmResults<Shop> response = await ShopService().getShop(name: name);
      if (response.isNotEmpty) {
        if (name.isNotEmpty) {
          allShops.assignAll(
              response.where((e) => e.name!.contains(name)).toList());
        } else {
          allShops.assignAll(response.map((e) => e).toList());
        }
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
      await ShopService().updateItem(shop!,
          name: nameController.text,
          currency: currency.value == ""
              ? Constants.currenciesData[0]
              : currency.value,
          type: Get.find<ShopController>().selectedCategory.value,
          location: reqionController.text);
      getShops();
      refresh();
      if (isSmallScreen(Get.context)) {
        Get.back();
      } else {
        Get.find<HomeController>().selectedWidget.value = ShopsPage();
      }

      showSnackBar(message: "shop updated", color: Colors.green);
      updateShopLoad.value = false;
    } catch (e) {
      updateShopLoad.value = false;
    }
  }

  checkDaysRemaining() {
    if (allowSubscription == false) return 999999;
    int days = currentShop.value!.subscriptiondate == null
        ? 0
        : DateTime.fromMillisecondsSinceEpoch(
                currentShop.value!.subscriptiondate!)
            .add(Duration(days: currentShop.value!.package!.time!))
            .difference(DateTime.now())
            .inDays;
    return days;
  }

  checkIfTrial() {
    if (allowSubscription == false) return allowSubscription;
    int days = currentShop.value?.package == null
        ? 14
        : currentShop.value!.package!.time!;
    return days == 14;
  }

  checkSubscription() {
    if (allowSubscription == false) return !allowSubscription;
    Packages? packages = currentShop.value?.package;
    if (packages != null) {
      DateTime subscriptionedndate = DateTime.fromMillisecondsSinceEpoch(
              currentShop.value!.subscriptiondate!)
          .add(Duration(days: packages.time!));
      var active = subscriptionedndate.millisecondsSinceEpoch >
          currentShop.value!.subscriptiondate!;
      return active;
    }
    return false;
  }

  deleteShop({required Shop shop, required context}) async {
    Get.find<RealmController>().deleteShopData(shop);

    //update current shop
    RealmResults<Shop> response = ShopService().getShop();
    if (response.isNotEmpty) {
      Users().updateAdmin(userController.user.value!, shop: response.first);
      Get.offAll(() => Home());
    } else {
      Users().updateAdmin(userController.user.value!, shop: null);
      Get.off(() => CreateShop(
            page: "home",
            clearInputs: true,
          ));
    }

    userController.getUser();
  }

  getCategories() async {
    try {
      loadingcateries.value = true;
      RealmResults<ShopTypes> response = ShopService().getShopTypes();
      categories.value = response.map((e) => e).toList();
      loadingcateries.value = false;
    } catch (e) {
      loadingcateries.value = false;
    }
  }
}
