import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';

import 'client.dart';

class Expense {
  createExpense({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest("$expenses", DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getExpenseByDate(
      {required shopId, required startDate, required endDate}) async {
    var response = await DbBase().databaseRequest("$expenses/$shopId/$startDate/$endDate", DbBase().getRequestType);
    return jsonDecode(response);


  }

}
