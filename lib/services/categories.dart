import 'dart:convert';

import 'client.dart';

class Categories {
  createExpenseCategories({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest("", DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getExpenseCategories({required id}) async {
    var response = await DbBase().databaseRequest("", DbBase().getRequestType);
    return jsonDecode(response);
  }
}
