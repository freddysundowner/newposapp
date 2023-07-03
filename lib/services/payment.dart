import 'package:get/get.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:realm/realm.dart';

import '../controllers/shop_controller.dart';

class Payment {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createPayHistory(PayHistory payHistory) async {
    realmService.realm.write<PayHistory>(
        () => realmService.realm.add<PayHistory>(payHistory));
  }

  deletePayments(List<PayHistory> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  RealmResults<PayHistory> getPaymentsByShop({Shop? shop}) {
    RealmResults<PayHistory> payments = realmService.realm
        .query<PayHistory>('shop == \$0', [shop?.id.toString()]);
    return payments;
  }
}
