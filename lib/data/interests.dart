import 'package:pointify/Real/schema.dart';
import 'package:realm/realm.dart';

import '../services/shop_services.dart';

class Interests {
  Interests() {
    createInterests();
  }
  static List roles = [
    "📷 Electronics",
    "🛠️ Hardware",
    "👸 Beauty Shop",
  ];

  static createInterests() {
    RealmResults<ShopTypes> shopcategories = ShopService().getShopTypes();
    print("shopcategories ${shopcategories.length}");
    if (shopcategories.isEmpty) {
      for (var element in roles) {
        print(element);
        ShopTypes shopTypes = ShopTypes(ObjectId(), title: element);
        ShopService().createShopType(shopTypes);
      }
    }
  }
}
