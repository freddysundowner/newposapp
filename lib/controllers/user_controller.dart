import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/plan_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/services/transactions.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../screens/home/home.dart';
import '../screens/shop/create_shop.dart';
import '../services/shop_services.dart';
import '../services/users.dart';

class UserController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController attendantId = TextEditingController();
  RxBool creatingAttendantsLoad = RxBool(false);
  RxBool getAttendantsLoad = RxBool(false);
  RxBool getAttendantByIdLoad = RxBool(false);
  Rxn<UserModel> user = Rxn(null);
  Rxn<UserModel> currentAttendant = Rxn(null);
  Rxn<UserModel> switcheduser = Rxn(null);
  RxList roles = RxList([]);

  RxString activeItem = RxString("");
  RxString activePermission = RxString("");
  ShopController shopController = Get.find<ShopController>();
  RxList permissions = RxList([
    {
      "key": "sales",
      "value": ['add', 'view', 'discount', "return", "edit_price", "manage"],
    },
    {
      "key": "accounts",
      "value": [
        'reports',
        'cashflow',
        'profits',
        "sales",
        "expenses",
        "analysis"
      ],
    },
    {
      "key": "stocks",
      "value": [
        'add',
        'view',
        'purchases',
        'count',
        'badstock',
        'transfer',
        'reports',
        'return',
        "edit_price",
        "stock_summary"
      ],
    },
    {
      "key": "purchases",
      "value": ['return']
    },
    {
      "key": "suppliers",
      "value": ['manage', 'view', 'all_purchases']
    },
    {
      "key": "customers",
      "value": ['manage', 'view', 'deposit', "all_sales"]
    },
    {
      "key": 'shop',
      "value": ["manage", "switch", "view"],
    },
    {
      "key": 'attendants',
      "value": ["manage", "view"],
    },
    {
      "key": 'products',
      "value": ["add", "manage"],
    },
    {
      "key": 'usage',
      "value": ["manage"],
    },
  ]);

  getRoles(UserModel userModel) {
    var all = [];
    if (userModel.permisions != null) {
      List perms = jsonDecode(userModel.permisions!);
      for (var element in perms) {
        all.add({"key": element["key"], "value": jsonDecode(element["value"])});
      }
    }
    roles.value = all;
  }

  int countDown = 0;

  countDownTimer() async {
    for (int x = 5; x > 0; x--) {
      await Future.delayed(const Duration(seconds: 1)).then((_) {
        print(x);
        if (x == 1) {
          RealmResults<UserModel> userdata = Users.getUserUser();
          print(x);

            userController.user.value = userdata.first;
            Get.find<PlanController>().getPlans();
            var shop = ShopService().getShop();
            Get.find<AuthController>().loginuserLoad.value = false;
            print("shops ${shop.length}");
            if (shop.isEmpty) {
              Get.offAll(() =>
                  CreateShop(
                    page: "home",
                    clearInputs: true,
                  ));
            } else {
              Get.offAll(() => Home());
            }

        }
      });
    }
  }
  getUser({String? type, int? uid}) async {
    if(type == "login"){
      countDownTimer();
    }else {
      RealmResults<UserModel> userdata = Users.getUserUser(uid: uid);
      user.value = userdata.first;
      if (userdata.isNotEmpty &&
          userdata
              .map((e) => e)
              .toList()
              .first
              .shop != null) {
        shopController.currentShop.value =
            userdata
                .map((e) => e)
                .toList()
                .first
                .shop;
      } else {
        print("user.value ${user.value}");
        RealmResults<Shop> response = await ShopService().getShop();
        if (response.isNotEmpty) {
          shopController.currentShop.value = response.first;
        }
      }
      await _createDefaultCashFlowCategory();
      if (user.value!.usertype == "attendant") {
        getRoles(user.value!);
        roles.refresh();
      }
      shopController.currentShop.refresh();
    }

  }

  Future<void> _createDefaultCashFlowCategory() async {
    if (Get.find<ShopController>().currentShop.value == null) return;
    RealmResults<CashFlowCategory> cashoutGroups = await Users.cashoutGroups();
    if (cashoutGroups.isEmpty) {
      CashFlowCategory cashFlowCategory = CashFlowCategory(ObjectId(),
          name: "Bank",
          key: "bank",
          amount: 0,
          shop: Get.find<ShopController>().currentShop.value!.id.toString(),
          type: "cash-out");
      Transactions().createCategory(cashFlowCategory);
    } else {
      List found = cashoutGroups.map((e) => e.key == "bank").toList();
      if (found.isEmpty) {
        CashFlowCategory cashFlowCategory = CashFlowCategory(ObjectId(),
            name: "Bank",
            key: "bank",
            amount: 0,
            shop: Get.find<ShopController>().currentShop.value!.id.toString(),
            type: "cash-out");
        Transactions().createCategory(cashFlowCategory);
      }
      Get.find<CashflowController>().getCategory(
          "cash-out", Get.find<ShopController>().currentShop.value);
    }
  }

  clearTextFields() {
    nameController.text = "";
    passwordController.text = "";
  }

  getAttendantsById({UserModel? userr, int? uid}) async {
    RealmResults<UserModel> response =
        Users.getUserUser(userModel: userr, uid: uid);
    UserModel userModel = response.first;
    currentAttendant.value = userModel;
    user.value = userModel;
    shopController.currentShop.value = userModel.shop;
    print(userModel.roles.length);
    refresh();
    return userModel;
  }

  deleteAttendant({UserModel? userModel}) async {
    Users.deleteUser(userModel!);
  }

  //
  updateUser({required UserModel userModel, String? permissions}) {
    Users().updateAdmin(userModel,
        username: nameController.text, permissions: permissions);
    generalAlert(
        title: "Updated",
        message: "Permissions updated successfully",
        negativeText: "");
  }


}
