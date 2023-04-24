import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';

import 'client.dart';

class Sales {
  createSales(Map<String, dynamic> salesdata) async {
    var response = await DbBase()
        .databaseRequest(sales, DbBase().postRequestType, body: salesdata);
    var data = jsonDecode(response);
    return data;
  }

  getSalesByDate(shopId, startDate, endDate) async {
    var response = await DbBase().databaseRequest(
        sales + "todaysales/" + shopId + "/" + startDate + "/" + endDate,
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getSalesBySaleId(uid) async {
    var response = await DbBase()
        .databaseRequest(singleSaleItems + uid, DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  getShopSales(shopId,attendantId,onCredit,date) async {
    var response = await DbBase()
        .databaseRequest(sales + "allsales/$shopId?attendant=$attendantId&oncredit=$onCredit&startdate=$date", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }


  retunSale(id) async {
    var response = await DbBase().databaseRequest(
        sales + "returnproduct/${id}", DbBase().postRequestType);
    var data = jsonDecode(response);
    return data;
  }
}
