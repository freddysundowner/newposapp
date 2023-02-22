import 'dart:convert';

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
        .databaseRequest(supplier + id, DbBase().patchRequestType);
    return jsonDecode(response);
  }

  deleteCustomer({required id}) async{
    var response = await DbBase()
        .databaseRequest(supplier + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }

}
