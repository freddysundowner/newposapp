import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Purchases {
  createPurchase({required Map<String, dynamic> body, required shopId}) async {
    var response = await DbBase().databaseRequest(
        purchases + "updatepurchases/${shopId}", DbBase().patchRequestType,
        body: body);
    return jsonDecode(response);
  }

  getPurchase({required shopId, String? attendantId, required customer}) async {
    var response = await DbBase().databaseRequest(
        purchases +
            "purchase?shop=${shopId}&attendant=${attendantId}&customer=$customer",
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  getPurchaseOrderItems({required id}) async {
    var response = await DbBase().databaseRequest(
        purchases + "purchaseditems/${id}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  returnOrderToSupplier(uid) async {
    var response = await DbBase().databaseRequest(
        purchases + "returns/${uid}", DbBase().patchRequestType);
    var data = jsonDecode(response);
    return data;
  }
}
