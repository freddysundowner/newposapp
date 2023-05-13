import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';

class Shop {
  createShop({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(shop, DbBase().postRequestType, body: body);

    return jsonDecode(response);
  }

  getShops({required adminId, String? name}) async {
    var response = await DbBase().databaseRequest(
        name == null || name == "" ? adminShop + adminId : "$searchShop/$name/",
        DbBase().getRequestType,
        body: {"id": adminId});
    return jsonDecode(response);
  }

  updateShops({required shopId, required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        updateShop + shopId, DbBase().patchRequestType,
        body: body);

    return jsonDecode(response);
  }

  getShopById({required id}) async {
    var response =
        await DbBase().databaseRequest(shop + id, DbBase().getRequestType);

    return jsonDecode(response);
  }

  deleteShop({required id}) async {
    var response =
        await DbBase().databaseRequest(shop + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

  static getCategories() async {
    var response = await DbBase()
        .databaseRequest(getshopcategories, DbBase().getRequestType);
    return jsonDecode(response);
  }
}
