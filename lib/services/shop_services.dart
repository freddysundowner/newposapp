import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/main.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';

class ShopService {
  final RealmController realmService = Get.find<RealmController>();
  void createShop(Shop shop) {
    realmService.realm.write<Shop>(() => realmService.realm.add<Shop>(shop));
  }

  void createShopType(ShopTypes shopTypes) {
    realmService.realm
        .write<ShopTypes>(() => realmService.realm.add<ShopTypes>(shopTypes));
  }

  getShop({String name = ""}) {
    print("userController.user.value!.usertype ${userController.user.value}");
    if (userController.user.value?.usertype !=null && userController.user.value?.usertype == "attendant" &&
        checkPermission(category: "stocks", permission: "transfer")) {
      RealmResults<Shop> shops = realmService.realm.query<Shop>(
          r'owner == $0', [userController.user.value?.shop?.owner]);
      return shops;
    } else {
      print("realmService.currentUser?.value?.id.toString() ${realmService.currentUser?.value?.id.toString()}");
      RealmResults<Shop> shops = realmService.realm
          .query<Shop>(r'owner == $0', [realmService.currentUser?.value?.id.toString()]);
      return shops;
    }
  }

  RealmResults<ShopTypes> getShopTypes() {
    RealmResults<ShopTypes> shopTypes = realmService.realm.all();
    return shopTypes;
  }

  deleteItem(Shop item) {
    realmService.realm.write(() => realmService.realm.delete(item));
  }

  Future<void> updateItem(Shop shop,
      {String? name,
      String? location,
      Packages? package,
      String? currency,
      ShopTypes? type}) async {
    realmService.realm.write(() {
      if (name != null) {
        shop.name = name;
      }

      if (location != null) {
        shop.location = location;
      }
      if (currency != null) {
        shop.currency = currency;
      }
      if (type != null) {
        shop.type = type;
      }
      if (package != null) {
        shop.package = package;
        shop.subscriptiondate = DateTime.now().millisecondsSinceEpoch;
      }
    });
  }
}
