import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Customer {
  createCustomer(Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(customer, DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getCustomersByShopId(String shopId) async {
    var response = await DbBase()
        .databaseRequest(customer + "shop/${shopId}", DbBase().getRequestType);
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
    return jsonDecode(response);
  }

  deleteCustomer({required id}) async {
    var response = await DbBase()
        .databaseRequest(customer + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }
}