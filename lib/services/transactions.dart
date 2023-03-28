import 'dart:convert';

import 'package:flutterpos/services/client.dart';

import 'apiurls.dart';

class Transactions {
  getProfitTransactions(shopId, startDate, endDate) async {
    var response = await DbBase().databaseRequest(
      "$transaction/salessummary/$shopId/$startDate/$endDate",
      DbBase().getRequestType,
    );
    return jsonDecode(response);
  }

  getCashAtBank(shopId) async {
    var response = await DbBase().databaseRequest(
        "$cashflow" + "banks/balances/$shopId/", DbBase().getRequestType);

    return jsonDecode(response);
  }

  createBank({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "$cashflow/create/bank", DbBase().postRequestType,
        body: body);

    return jsonDecode(response);
  }

  getBankNames(shopId) async {
    var response = await DbBase().databaseRequest(
      category + "banklist/${shopId}",
      DbBase().getRequestType,
    );
    var data = jsonDecode(response);
    return data;
  }

  createTransaction({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(cashflow, DbBase().postRequestType, body: body);
    var data = jsonDecode(response);
    return data;
  }

  createCategory({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category", DbBase().postRequestType,
        body: body);
    var data = jsonDecode(response);
    return data;
  }

  getCategory({required shop, required type}) async {
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "$shop/$type", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getBakTransactions({required id}) async {
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "bank/bank/transactions/$id", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getCategoryHistory({required id})async{
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category/category/$id", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  ediCategory({required Map<String, dynamic> body, required id})async{
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category/$id", DbBase().patchRequestType,body: body);
    var data = jsonDecode(response);
    return data;
  }

  deleteCategory({String? id}) async{
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category/$id", DbBase().deleteRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getCashFlowSummary({required id, required date}) async{
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "salessummary/$id/$date", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }
}
