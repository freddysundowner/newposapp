import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Purchases {
  createPurchase({required Map<String, dynamic> body, required shopId}) async {
    var response = await DbBase().databaseRequest(
        product + "updatepurchases/${shopId}", DbBase().patchRequestType,
        body: body);
    return jsonDecode(response);
  }

  getPurchase({required shopId}) async {
    var response = await DbBase().databaseRequest(
        product + "purchase/${shopId}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  getPurchaseOrderItems({required id}) async {
    var response = await DbBase()
        .databaseRequest(product + "purchase/${id}", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
