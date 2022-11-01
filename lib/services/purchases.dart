import 'dart:convert';

import 'package:flutterpos/services/client.dart';

class Purchases {
  createPurchase({required Map<String, dynamic> body, required shopId}) async {
    var response = await DbBase()
        .databaseRequest("link", DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }
}
