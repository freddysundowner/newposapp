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

  getPurchase({required shopId}) async {
    var response = await DbBase().databaseRequest(
        purchases + "purchase/${shopId}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  getPurchaseOrderItems({required id}) async {
    var response = await DbBase().databaseRequest(
        purchases + "purchaseditems/${id}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  returnOrderToSupplier(uid, body) async {
    var response = await DbBase().databaseRequest(
        purchases + "return/${uid}", DbBase().patchRequestType,
        body: body);

    var data = jsonDecode(response);
    return data;
  }
}
