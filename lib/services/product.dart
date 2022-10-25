import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';

import 'client.dart';


class Product {
  createProduct(Map<String, dynamic> body) async{
    var response = await DbBase()
        .databaseRequest(product, DbBase().postRequestType, body: body);

    return jsonDecode(response);
  }

  getProductsBySort(String shopId, String type) async {
    var response = await DbBase().databaseRequest(
        type=="all"?product + "shop/${shopId}":
        product + "${shopId}/${type}", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  searchProduct(String shopId, String text) async {
    var response = await DbBase().databaseRequest(
        product + "search/${shopId}/${text}", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  deleteProduct({required id}) async{
    var response = await DbBase().databaseRequest(product+id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

}
