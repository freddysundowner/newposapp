import 'dart:convert';

import 'apiurls.dart';
import 'client.dart';

class Categories {
  createProductCategory({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(category, DbBase().postRequestType, body: body);

    return jsonDecode(response);
  }

  getProductCategories(shopId) async {

    var response = await DbBase()
        .databaseRequest(category + "shop/${shopId}", DbBase().getRequestType);


    return jsonDecode(response);
  }
}
