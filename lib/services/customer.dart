import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Customer {
  createCustomer(Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(customer, DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getCustomersByShopId(String shopId, String type) async {
    var response = await DbBase().databaseRequest(
        type == "all"
            ? customer + "shop/${shopId}"
            : "$customersOnCredit/${shopId}",
        DbBase().getRequestType);
    return jsonDecode(response);
  }

  getCustomersById(id) async {
    var response =
        await DbBase().databaseRequest(customer + id, DbBase().getRequestType);
    return jsonDecode(response);
  }

  updateCustomer({required Map<String, dynamic> body, required id}) async {
    var response = await DbBase()
        .databaseRequest(customer + id, DbBase().patchRequestType);
    print("response is ${response}");
    return jsonDecode(response);
  }

  deleteCustomer({required id}) async {
    var response = await DbBase()
        .databaseRequest(customer + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

  getPurchases(uid, type) async {
    var response = await DbBase()
        .databaseRequest(customerPurchase + uid, DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  getReturns(uid) async {
    var response = await DbBase()
        .databaseRequest(customerReturns + uid, DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }
}
