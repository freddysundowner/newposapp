import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/services/transactions.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:realm/realm.dart';

import '../Real/Models/schema.dart';
import '../Real/services/r_shop.dart';
import '../data/interests.dart';
import '../services/users.dart';

class UserController extends GetxController {
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController attendantId = TextEditingController();
  RxBool creatingAttendantsLoad = RxBool(false);
  RxBool getAttendantsLoad = RxBool(false);
  RxBool getAttendantByIdLoad = RxBool(false);
  RxList<UserModel> users = RxList([]);
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
      "value": ['add', 'view', 'discount', "return", "edit_price"],
    },
    {
      "key": "accounts",
      "value": ['reports', 'cashflow', 'profits', "sales", "expenses"],
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
      "value": ["add", "switch", "delete", "view"],
    },
    {
      "key": 'attendants',
      "value": ["add", "delete", "view"],
    },
    {
      "key": 'products',
      "value": ["add", "delete", "edit"],
    },
    {
      "key": 'usage',
      "value": ["view"],
    },
  ]);

  getRoles(UserModel userModel) {
    List perms = jsonDecode(userModel.permisions!);
    var all = [];
    perms.forEach((element) {
      all.add({"key": element["key"], "value": jsonDecode(element["value"])});
    });
    print("all roles $all");
    roles.value = all;
  }

  getUser({String? type}) async {
    Interests();
    RealmResults<UserModel> userdata = await Users.getUserUser();
    if (type == "login") {
      if (userdata.isEmpty) {
        Users.createUser(UserModel(
          ObjectId.fromHexString(
              Get.find<RealmController>().currentUser!.value!.id),
          Random().nextInt(098459),
          usertype: "admin",
          deleted: false,
          fullnames:
              Get.find<RealmController>().currentUser?.value!.profile.name,
        ));
        userdata = await Users.getUserUser();
        return;
      }
    }
    if (userdata.isEmpty) {
      await appController.logOut();
      return;
    }
    user.value = userdata.first;
    if (userdata.isNotEmpty &&
        userdata.map((e) => e).toList().first.shop != null) {
      shopController.currentShop.value =
          userdata.map((e) => e).toList().first.shop;
    } else {
      RealmResults<Shop> response = await RShop().getShop();
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
      print("found ${found.length}");
      if (found.isEmpty) {
        CashFlowCategory cashFlowCategory = CashFlowCategory(ObjectId(),
            name: "Bank",
            key: "bank",
            amount: 0,
            shop: Get.find<ShopController>().currentShop.value!.id.toString(),
            type: "cash-out");
        Transactions().createCategory(cashFlowCategory);
      }
      Get.find<CashflowController>().getCategory("cash-out");
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
  updateAttedant({required UserModel userModel, String? permissions}) {
    print("updateAttedant");
    Users().updateAdmin(userModel,
        username: nameController.text, permissions: permissions);
    generalAlert(
        title: "Updated",
        message: "Permissions updated successfully",
        negativeText: "");
  }
}
