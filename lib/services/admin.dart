import 'dart:convert';

import 'package:flutterpos/services/apiurls.dart';
import 'package:flutterpos/services/client.dart';

class Admin{

  createAdmin({required Map<String, dynamic> body})async{
   var user= await DbBase().databaseRequest(admin, DbBase().postRequestType,body: body);
   return jsonDecode(user);
  }

  loginAdmin({required Map<String, dynamic> body}) async{
    var user= await DbBase().databaseRequest(adminLogin, DbBase().postRequestType,body: body);
    return jsonDecode(user);
  }

  updateAdmin({required Map<String, dynamic> body, required id}) async{
    var user= await DbBase().databaseRequest(admin+"/update/${id}", DbBase().patchRequestType,body: body);
    return jsonDecode(user);
  }

  getUserById(String id) async{
    var user= await DbBase().databaseRequest(admin+"/${id}", DbBase().getRequestType);
    return jsonDecode(user);
  }


}