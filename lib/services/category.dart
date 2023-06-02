import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import 'apiurls.dart';
import 'client.dart';

class Categories {
  final RealmController realmService = Get.find<RealmController>();
  createProductCategory(ProductCategory body) async {
    realmService.realm.write<ProductCategory>(
        () => realmService.realm.add<ProductCategory>(body));
  }

  Stream<RealmResultsChanges<ProductCategory>> getProductCategories() {
    print("getProductCategories");
    return realmService.realm.query<ProductCategory>(
        r'shop == $0', [Get.find<ShopController>().currentShop.value]).changes;
  }
}
