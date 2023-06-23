import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';

class Categories {
  final RealmController realmService = Get.find<RealmController>();
  Stream<RealmResultsChanges<ProductCategory>> getProductCategories() {
    print("sdfs ${Get.find<ShopController>().currentShop.value!.type!.id}");
    return realmService.realm.query<ProductCategory>(r'shopTypes == $0',
        [Get.find<ShopController>().currentShop.value!.type]).changes;
  }

  createProductCategory(ProductCategory body) async {
    realmService.realm.write<ProductCategory>(
        () => realmService.realm.add<ProductCategory>(body));
  }
}
