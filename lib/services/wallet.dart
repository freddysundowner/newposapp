import 'dart:convert';

import 'apiurls.dart';
import 'client.dart';

class Wallet {
  createWallet(Map<String, dynamic> body, uid) async {

    var response = await DbBase().databaseRequest(
        "${customerDeposit}" + uid, DbBase().putRequestType,
        body: body);

    return jsonDecode(response);
  }

  getWallet(uid,type) async {
    var response = await DbBase().databaseRequest(
        "${customerTransaction}"+ uid, DbBase().getRequestType,body: {"type":type});
    return jsonDecode(response);
  }


  updateWallet(uid, body) async {
    var response = await DbBase()
        .databaseRequest(wallet + uid, DbBase().putRequestType, body: body);
    return jsonDecode(response);
    ;
  }

  deleteWallet(uid, Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(wallet + uid, DbBase().deleteRequestType, body: body);
    return jsonDecode(response);
  }

}
