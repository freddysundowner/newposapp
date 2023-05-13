import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';

String htmlPrice(amount) =>
    "${Get.find<ShopController>().currentShop.value?.currency.toString().toUpperCase()} $amount";
