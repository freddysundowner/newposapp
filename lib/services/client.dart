import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DbBase {

  final postRequestType = "POST";
  final getRequestType = "GET";
  final putRequestType = "PUT";
  final patchRequestType = "PATCH";
  final deleteRequestType = "DELETE";

  databaseRequest(String link, String type, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      if (headers == null) {
        headers = {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + (token ?? "")
        };
      }
      var request = http.Request(type, Uri.parse(link));
      print("thim $type ${link}");
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 404) {
        //  AuthAPI().getToken();
      }
      return response.stream.bytesToString();
    } catch (e) {
      print(e);
    }
  }
}