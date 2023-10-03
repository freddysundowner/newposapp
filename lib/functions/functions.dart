import 'dart:math';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:flutter/material.dart';

import '../Real/schema.dart';

String htmlPrice(amount) {
  return "${Get.find<ShopController>().currentShop.value?.currency.toString().toUpperCase()} ${amount}";
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

List<int> getYears(int year) {
  int currentYear = DateTime.now().year;

  List<int> yearsTilPresent = [];

  while (year <= currentYear) {
    yearsTilPresent.add(year);
    year++;
  }

  return yearsTilPresent;
}

showDate(int date) => Text(
      '${DateFormat("MMM dd yyyy hh:mm a").format(DateTime.fromMillisecondsSinceEpoch(date))} ',
      style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
    );

getYearlyRecords(Product product,
    {required Function function, required int year}) {
  DateTime now = DateTime(year, 1);
  DateTime firstDayofYear = DateTime(now.year, now.month, 1);
  DateTime now2 = DateTime(year, 12);
  DateTime lastDayofYear = DateTime(now2.year, now2.month + 1, 0);
  function(product, firstDayofYear, lastDayofYear);
}

void getMonthlyProductSales(Product product, int i,
    {required Function function, required int year}) {
  DateTime now = DateTime(year, i + 1);
  var lastday = DateTime(now.year, now.month + 1, 0).add(Duration(hours: 24));
  final noww = DateTime(year, i + 1);
  var firstday = DateTime(noww.year, noww.month, 1);

  function(product, firstday, lastday);
}

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
