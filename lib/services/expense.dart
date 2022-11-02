import 'dart:convert';

import 'client.dart';

class Expense {
  createExpense({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest("", DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getExpenseByDate(
      {required shopId, required startDate, required endDate}) async {
    var response = await DbBase().databaseRequest("", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
