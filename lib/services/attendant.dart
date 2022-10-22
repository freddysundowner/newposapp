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

  getAttendantsById(shopId) async {
    var response = await DbBase()
        .databaseRequest(attendant + "shop/${shopId}", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
