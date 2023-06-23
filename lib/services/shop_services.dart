import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/schema.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';

class ShopService {
  final RealmController realmService = Get.find<RealmController>();
  void createShop(Shop shop) {
    realmService.realm.write<Shop>(() => realmService.realm.add<Shop>(shop));
  }

  void createShopType(ShopTypes shopTypes) {
    print("createShopType");
    realmService.realm
        .write<ShopTypes>(() => realmService.realm.add<ShopTypes>(shopTypes));
  }

  getShop({String name = ""}) {
    RealmResults<Shop> shops = realmService.realm
        .query<Shop>(r'owner == $0', [realmService.currentUser!.value!.id]);
    if (name.isNotEmpty) {
      RealmResults<Shop> shopsFiltered =
          shops.query('name BEGINSWITH \$0', [name]);
      return shopsFiltered;
    }
    return shops;
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
      String? currency,
      ShopTypes? type}) async {
    realmService.realm.write(() {
      shop.name = name;
      shop.location = location;
      shop.currency = currency;
      shop.type = type;
    });
  }
}
