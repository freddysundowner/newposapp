import 'dart:convert';

import 'apiurls.dart';
import 'client.dart';

class Wallet {
  createWallet(Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(wallet, DbBase().postRequestType, body: body);
    print("wewe${response}");
    return jsonDecode(response);
  }

  getWallet(uid) async {
    var response = await DbBase().databaseRequest(
        wallet + "customerwallet/" + uid, DbBase().getRequestType);
    return jsonDecode(response);
  }

  getusage(uid) async {
    var response =
        await DbBase().databaseRequest(usage + uid, DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  updateWallet(uid, body) async {
    var response = await DbBase()
        .databaseRequest(wallet + uid, DbBase().patchRequestType, body: body);
    return jsonDecode(response);
    ;
  }

  deleteWallet(uid, Map<String, dynamic> body) async {
    var response = await DbBase()
        .databaseRequest(wallet + uid, DbBase().deleteRequestType, body: body);
    return jsonDecode(response);
  }

// getShopWallet(uid) async{
//   var response = await DbBase()
//       .databaseRequest(trackDeposit + "totalshopwallet/${uid}", DbBase().getRequestType);
//   var data = jsonDecode(response);
//   return response;
// }
}
