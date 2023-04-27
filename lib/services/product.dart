import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';

import 'client.dart';

class Products {
  createProduct(Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(product, DbBase().postRequestType, body: body);

    return jsonDecode(response);
  }

  getProductsBySort(String shopId, String type) async {
    var response = await DbBase().databaseRequest(
        type == "all"
            ? product + "shop/${shopId}"
            : product + "${type}/${shopId}",
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  searchProduct(String shopId, String text) async {
    var response = await DbBase().databaseRequest(
        product + "search/${shopId}/${text}", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  deleteProduct({required id}) async {
    var response = await DbBase()
        .databaseRequest(product + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

  getProductHistory({required productId, required String type, required stockId}) async {
    var response = await DbBase().databaseRequest(
        "${productHistory}?type=${type}&stockId=${stockId}&product=$productId", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;

  }

  updateProduct({required id, required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        product + "update/${id}", DbBase().patchRequestType,
        body: body);
    return jsonDecode(response);
  }

  getProductCountInShop(String shopId, String type, startDate, endDate) async {
    var response = await DbBase().databaseRequest(
        product +
            "filter?shopid=${shopId}&type=${type}&startDate=${startDate}&endDate=${endDate}",
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  updateProductCount(Map<String, dynamic> body) async {
    var response = await DbBase().databaseRequest(
        product + "increasecount/", DbBase().postRequestType,
        body: body);

    var data = jsonDecode(response);
    return data;
  }

  getProductCount(id) async {
    var response = await DbBase().databaseRequest(
        product + "productcount?shop=${id}", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  transferProducts({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(stocktransfer, DbBase().postRequestType, body: body);
    var data = jsonDecode(response);
    return data;
  }

  getTransHistory({required shopId, required type}) async {
    var response = await DbBase().databaseRequest(
        "${stocktransfer}?shop=$shopId&type=$type", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }
  getTransHistoryItems({required shopId, required type}) async {
    var response = await DbBase().databaseRequest(
        "${stocktransfer}?shop=$shopId&type=$type", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getProductSaleHistory(productId) {}

  saveBadStock({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(badstock, DbBase().postRequestType, body: body);
    var data = jsonDecode(response);
    return data;
  }

  getBadStock(shopId, attendant,product) async {
    var response = await DbBase().databaseRequest(
      "${badstock}shop?shop=$shopId&attendant=$attendant&product=$product",
      DbBase().getRequestType,
    );
    var data = jsonDecode(response);
    return data;
  }
}
