import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/models/stock_in_credit.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';

class Supplier {
  createSupplier(Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(supplier, DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getSuppliersByShopId(shopId, type) async {
    var response = await DbBase().databaseRequest(
        type == "all"
            ? "${supplier}shop/${shopId}"
            : "$supplierOnCredit/${shopId}",
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  getSupplierById(id) async {
    var response =
        await DbBase().databaseRequest(supplier + id, DbBase().getRequestType);
    return jsonDecode(response);
  }

  updateSupplier({required Map<String, dynamic> body, id}) async {
    var response = await DbBase()
        .databaseRequest(supplier + id, DbBase().patchRequestType, body: body);
    return jsonDecode(response);
  }

  deleteCustomer({required id}) async {
    var response = await DbBase()
        .databaseRequest(supplier + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

  deleteStockProduct(String productId) async {
    var response = await DbBase().databaseRequest(
        product + "deletestockin/${productId}", DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  paySupplyCredit(
      StockInCredit stockInCredit, Map<String, dynamic> body) async {
    var response = await DbBase().databaseRequest(
        supplier + "pay/${stockInCredit.id}", DbBase().patchRequestType,
        body: body);
    return jsonDecode(response);
  }

  getCredit(shopId, uid) async {
    var response = await DbBase().databaseRequest(
        supplier + "stockinhistory/${shopId}/${uid}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  getSupplierSupplies({required supplierId, required returned}) async {
    var attendantId = Get.find<AuthController>().usertype.value == "admin"
        ? ""
        : Get.find<AttendantController>().attendant.value!.id;

    var response = await DbBase().databaseRequest(
        "${supplier}supplier/returns?supplier=$supplierId&attendant=$attendantId&returned=$returned",
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
