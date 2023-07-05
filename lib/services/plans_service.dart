import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/schema.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';

class PlansService {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createPackage(Packages packages) async {
    realmService.realm
        .write<Packages>(() => realmService.realm.add<Packages>(packages));
  }

  getPlans() {
    RealmResults<Packages> plans = realmService.realm.all();
    return plans;
  }
}
