import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Attendant {
  createAttendant({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(attendant, DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getRoles() async {
    var response =
        await DbBase().databaseRequest(roles, DbBase().getRequestType);
    return jsonDecode(response);
  }

  getAttendantsByShopId(shopId) async {
    var response = await DbBase()
        .databaseRequest(attendant + "shop/${shopId}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  getAttendantById(id) async {
    var response =
        await DbBase().databaseRequest(attendant + id, DbBase().getRequestType);
    return jsonDecode(response);
  }

  updatePassword(id, Map<String, dynamic> body) async {
    var response = await DbBase().databaseRequest(
        attendant + "password/${id}", DbBase().patchRequestType,
        body: body);
    return jsonDecode(response);
  }

  deleteAttendant(id) async {
    var response = await DbBase()
        .databaseRequest(attendant + id, DbBase().deleteRequestType);
    return jsonDecode(response);
  }
}
