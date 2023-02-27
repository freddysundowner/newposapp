import 'dart:convert';

import 'package:flutterpos/models/stock_in_credit.dart';
import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Supplier {

  createSupplier(Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(supplier, DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getSuppliersByShopId(shopId)async {
    var response = await DbBase().databaseRequest(supplier+"shop/${shopId}", DbBase().getRequestType);
    return jsonDecode(response);

  }

  getSupplierById(id)async {
    var response = await DbBase().databaseRequest(supplier+id, DbBase().getRequestType);
    return jsonDecode(response);
  }



  updateSupplier({required Map<String, dynamic> body, id})async {
    var response = await DbBase()
        .databaseRequest(supplier + id, DbBase().patchRequestType,body: body);
    return jsonDecode(response);
  }

  deleteCustomer({required id}) async{
    var response = await DbBase()
        .databaseRequest(supplier + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

  deleteStockProduct(String productId) async{
    var response = await DbBase()
        .databaseRequest(product+"deletestockin/${productId}", DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }
  paySupplyCredit(StockInCredit stockInCredit, Map<String, dynamic> body) async {
    var response = await DbBase().databaseRequest(
        supplier + "pay/${stockInCredit.id}", DbBase().patchRequestType,
        body: body);
    var data = jsonDecode(response);
    return data;
  }
  getCredit(shopId, uid) async {
    var response = await DbBase().databaseRequest(
        supplier + "stockinhistory/${shopId}/${uid}", DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  returnOrderToSupplier(uid, body) async {
    var response = await DbBase().databaseRequest(
        supplier + "return/${uid}", DbBase().patchRequestType,
        body: body);
    var data = jsonDecode(response);
    return data;
  }

  getSuppliersOnCredit(String? shopId) async{
    var response = await DbBase().databaseRequest("${supplierOnCredit}/${shopId}", DbBase().getRequestType);
    return jsonDecode(response);
  }


}
