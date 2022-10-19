import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Shop{

  createShop({required Map<String, dynamic> body})async{
    var response=await DbBase().databaseRequest(shop, DbBase().postRequestType,body: body) ;
    return jsonDecode(response);
  }

}