import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/services/apiurls.dart';

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
        "${salesbydate + shopId + "/" + startDate}/" + endDate,
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getSalesBySaleId(uid, productId) async {
    var response = await DbBase().databaseRequest(
        "$singleSaleItems?sale=$uid&product=${productId}",
        DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  getCustomerReturns(uid, productId) async {
    var response = await DbBase().databaseRequest(
        "$singleSaleItems?sale=$uid&product=${productId}",
        DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  getSales({required onCredit, required date, required customer, total}) async {
    var response = await DbBase().databaseRequest(
        "${sales}allsales/${Get.find<ShopController>().currentShop.value?.id}?attendant=${Get.find<AuthController>().usertype.value == "admin" ? "" : Get.find<AttendantController>().attendant.value!.id}&oncredit=$onCredit&startdate=${date ?? ""}&total=$total&customer=$customer",
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  retunSale(id, int quatity) async {
    var response = await DbBase().databaseRequest(
        "${sales}returnproduct/${id}", DbBase().postRequestType,
        body: {
          "quantity": quatity,
          "attendant": Get.find<AuthController>().currentUser.value?.id
        });
    var data = jsonDecode(response);
    return data;
  }

  createPayment({required Map<String, dynamic> body, required saleId}) async {
    var response = await DbBase().databaseRequest(
        "${sales}pay/credit/$saleId", DbBase().postRequestType,
        body: body);
    return jsonDecode(response);
  }

  getPaymentHistory({required String id, required String type}) async {
    var response = await DbBase().databaseRequest(
        type == "purchase"
            ? "${purchases}paymenthistory/$id"
            : "${sales}paymenthistory/$id",
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
