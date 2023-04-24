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
      {required shopId,
      required startDate,
      required endDate,
      required attendant}) async {
    var response = await DbBase().databaseRequest(
        "$expenses?shop=$shopId&fromDate=$startDate&toDate=$endDate&attendant=$attendant",
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
