import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';
import 'apiurls.dart';
import 'client.dart';

class Wallet {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  deposit(DepositModel depositModel) async {
    realmService.realm.write<DepositModel>(
        () => realmService.realm.add<DepositModel>(depositModel));
  }

  RealmResults<DepositModel> getWallet(CustomerModel customerModel, type) {
    RealmResults<DepositModel> deposits = realmService.realm
        .query<DepositModel>('customer == \$0', [customerModel]);
    return deposits
        .query("type == \$0  AND TRUEPREDICATE SORT(createdAt DESC)", [type]);
  }
}
