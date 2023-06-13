import 'dart:math';

import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';

String htmlPrice(amount) {
  return "${Get.find<ShopController>().currentShop.value?.currency.toString().toUpperCase()} $amount";
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

bool checkPermission(
    {required String category, permission, bool group = false}) {
  UserController usercontroller = Get.find<UserController>();
  if (usercontroller.switcheduser.value != null) {
    if (["sales", "accounts", "shop", "usage"].contains(category)) {
      return false;
    }
  }
  if (usercontroller.user.value?.usertype == "attendant") {
    List role =
        usercontroller.roles.where((p0) => p0["key"] == category).toList();
    if (role.isEmpty) return false;
    if (group) {
      return role.isNotEmpty;
    }
    List roleValue = role[0]["value"] as List;
    var index = roleValue.indexWhere((element) => element == permission) != -1;
    return index;
  }
  return true;
}

bool switchedUserCheckPermission(
    {required String category, permission, bool group = false}) {
  UserController usercontroller = Get.find<UserController>();
  List role =
      usercontroller.roles.where((p0) => p0["key"] == category).toList();
  List roleValue = role[0]["value"] as List;
  var index = roleValue.indexWhere((element) => element == permission) != -1;
  return index;
}
