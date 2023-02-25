import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';

import 'client.dart';

class Expense {
  createExpense({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest("$expense", DbBase().postRequestType, body: body);
    print("object$response");
    return jsonDecode(response);
  }

  getExpenseByDate(
      {required shopId, required startDate, required endDate}) async {
    var response = await DbBase().databaseRequest("$transaction/expense/$shopId/$startDate/$endDate", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
