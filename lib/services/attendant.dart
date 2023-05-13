import 'dart:convert';

import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';

class Attendant {
  createAttendant({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(attendant, DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  loginAttendant({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "${attendant}login", DbBase().postRequestType,
        body: body);
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

  updateAttendant({required id, required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        attendant + "update/${id}", DbBase().patchRequestType,
        body: body);
    return jsonDecode(response);
  }
}
