import 'dart:convert';

import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';

class PlansService {
  static getPlans() async {
    var response =
        await DbBase().databaseRequest(plans, DbBase().getRequestType);
    return jsonDecode(response);
  }
}
