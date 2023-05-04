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

  getSalesBySaleId(uid, productId) async {
    var response = await DbBase().databaseRequest(
        "${singleSaleItems}?sale=${uid}&product=${productId}",
        DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  getShopSales(
      {required shopId,
      required attendantId,
      required onCredit,
      required date,
      required customer}) async {
    var response = await DbBase().databaseRequest(
        "${sales}allsales/$shopId?attendant=$attendantId&oncredit=$onCredit&startdate=${date ?? ""}&customer=$customer",
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  retunSale(id) async {
    var response = await DbBase().databaseRequest(
        sales + "returnproduct/${id}", DbBase().postRequestType);
    var data = jsonDecode(response);
    return data;
  }

  createPayment({required Map<String, dynamic> body, required saleId}) async {
    var response = await DbBase().databaseRequest(
        sales + "pay/credit/$saleId", DbBase().postRequestType,
        body: body);
    return jsonDecode(response);
  }

  getPaymentHistory({required String id, required String type}) async {
    var response = await DbBase().databaseRequest(
        type == "purchase"
            ? purchases + "paymenthistory/$id"
            : sales + "paymenthistory/$id",
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
