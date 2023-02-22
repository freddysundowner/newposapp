import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';

import 'client.dart';

class Sales {
  createSales(Map<String, dynamic> salesdata) async {
    var response = await DbBase()
        .databaseRequest(sales, DbBase().postRequestType, body: salesdata);
    var data = jsonDecode(response);
    return data;
  }
}
