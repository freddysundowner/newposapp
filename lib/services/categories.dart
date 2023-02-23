import 'dart:convert';

import 'apiurls.dart';
import 'client.dart';

class Categories {
  createExpenseCategories({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest("$category", DbBase().postRequestType, body: body);
    return jsonDecode(response);
  }

  getExpenseCategories({required id}) async {
    var response = await DbBase().databaseRequest("$category/shop/"+id, DbBase().getRequestType);
    return jsonDecode(response);
  }
}
