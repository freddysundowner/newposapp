import 'package:pointify/Real/schema.dart';
import 'package:pointify/services/category.dart';
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
    // print(shopcategories[2].id);
    // print(shopcategories[2].title);
    // Categories().createProductCategory(ProductCategory(ObjectId(),
    //     name: "test2", shopTypes: shopcategories[1]));
    if (shopcategories.isEmpty) {
      for (var element in roles) {
        ShopTypes shopTypes = ShopTypes(ObjectId(), title: element);
        ShopService().createShopType(shopTypes);
      }
    }
  }
}
