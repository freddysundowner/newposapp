import 'package:get/get.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/realm_controller.dart';

import '../controllers/shop_controller.dart';

class Payment {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createPayHistory(PayHistory payHistory) async {
    realmService.realm.write<PayHistory>(
        () => realmService.realm.add<PayHistory>(payHistory));
  }
}
