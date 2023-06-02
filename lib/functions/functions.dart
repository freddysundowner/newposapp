import 'dart:math';

import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';

String htmlPrice(amount) {
  return "${Get.find<ShopController>().currentShop.value?.currency.toString().toUpperCase()} $amount";
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
