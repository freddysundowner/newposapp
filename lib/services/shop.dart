import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Shop {
  createShop({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(shop, DbBase().postRequestType, body: body);

    return jsonDecode(response);
  }

  getShopsByAdminId({required adminId, String? name}) async {
    var response = await DbBase().databaseRequest(
        name == null ||name==""? adminShop + adminId : "${searchShop}/$name/$adminId",
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  updateShops({required id, required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        updateShop + id, DbBase().patchRequestType,
        body: body);

    return jsonDecode(response);
  }

  deleteShop({required id}) async {
    var response =
        await DbBase().databaseRequest(shop + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }
}
