import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/screens/authentication/shop_cagories.dart';
import 'package:realm/realm.dart';

import '../Real/services/r_shop.dart';

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
    RealmResults<ShopTypes> shopcategories = RShop().getShopTypes();
    if (shopcategories.isEmpty) {
      for (var element in roles) {
        print(element);
        ShopTypes shopTypes = ShopTypes(ObjectId(), title: element);
        RShop().createShopType(shopTypes);
      }
    }
  }
}
