import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';

import '../controllers/AuthController.dart';

class Purchases {
  createPurchase({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "${purchases}updatepurchases/${Get.find<ShopController>().currentShop.value!.id}",
        DbBase().patchRequestType,
        body: body);

    return jsonDecode(response);
  }

  getPurchase({required supplier, required String onCredit}) async {
    var shopId = Get.find<ShopController>().currentShop.value!.id;
    var attendantId = Get.find<AttendantController>().attendant.value == null
        ? ""
        : Get.find<AttendantController>().attendant.value!.id;
    var response = await DbBase().databaseRequest(
        "${purchases}purchase?shop=${shopId}&attendant=${attendantId}&supplier=$supplier&oncredit=$onCredit",
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  getPurchaseOrderItems({required id, required productId}) async {
    var response = await DbBase().databaseRequest(
        "${purchases}purchaseditems?purchase=${id}&product=${productId}",
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  returnOrderToSupplier(uid) async {
    var response = await DbBase()
        .databaseRequest("${purchases}returns/$uid", DbBase().patchRequestType);
    var data = jsonDecode(response);
    return data;
  }

  createPayment({required Map<String, dynamic> body, String? saleId}) async {
    var response = await DbBase().databaseRequest(
        "${purchases}pay/credit/$saleId", DbBase().postRequestType,
        body: body);
    return jsonDecode(response);
  }

  retunPurchase(id, int quatity) async {
    var response = await DbBase().databaseRequest(
        "${purchases}returns/purchase/${id}", DbBase().patchRequestType,
        body: {
          "quantity": quatity,
          "attendant": Get.find<AuthController>().currentUser.value?.id
        });
    var data = jsonDecode(response);
    return data;
  }
}
