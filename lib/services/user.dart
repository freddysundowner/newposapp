import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class User{

  createAdmin({required Map<String, dynamic> body})async{
   var user= await DbBase().databaseRequest(admin, DbBase().postRequestType,body: body);
   return jsonDecode(user);
  }

  loginAdmin({required Map<String, dynamic> body}) async{
    var user= await DbBase().databaseRequest(adminLogin, DbBase().postRequestType,body: body);
    return jsonDecode(user);
  }


}