import 'dart:convert';

import 'package:flutterpos/services/client.dart';

import 'apiurls.dart';

class Transactions {
  getProfitTransactions(shopId,startDate,endDate) async {
    var response =
        await DbBase().databaseRequest("$allTransactions/$shopId/$startDate/$endDate", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
