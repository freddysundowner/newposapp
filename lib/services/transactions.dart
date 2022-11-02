import 'dart:convert';

import 'package:flutterpos/services/client.dart';

class Transactions {
  getProfitTransactions(shopId,startDate,endDate) async {
    var response =
        await DbBase().databaseRequest("link", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
