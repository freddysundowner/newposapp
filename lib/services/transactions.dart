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
        "$transaction/bybank/$shopId/", DbBase().getRequestType);
    return jsonDecode(response);
  }

  createBank({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "$transaction/createbank", DbBase().postRequestType,
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
        .databaseRequest(transaction, DbBase().postRequestType, body: body);
    var data = jsonDecode(response);
    return data;
  }
}
