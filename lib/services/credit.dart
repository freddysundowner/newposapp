import 'dart:convert';

import 'package:flutterpos/services/client.dart';

import 'apiurls.dart';


class Credit {
  getCredit(attendantId, shopId, uid) async {
    var response = await DbBase().databaseRequest(
        customer + "credit/" + attendantId + "/" + shopId + "/" + uid,
        DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  updateCredit(id, Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(credit + id, DbBase().patchRequestType, body: body);
    var data = jsonDecode(response);
    return data;
  }

  deleteCredit(id) async {
    var response =
    await DbBase().databaseRequest(credit + id, DbBase().deleteRequestType);
    var data = jsonDecode(response);
    return data;
  }
}