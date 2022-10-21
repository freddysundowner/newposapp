import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Attendant {
  createAttendant({required Map<String, dynamic> body}) async {
    var response=await DbBase().databaseRequest(attendant, DbBase().postRequestType,body: body);
    return jsonDecode(response);
  }
}
