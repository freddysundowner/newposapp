import 'dart:convert';

import 'package:http/http.dart' as http;

class DbBase {
  final postRequestType = "POST";
  final getRequestType = "GET";
  final putRequestType = "PUT";
  final patchRequestType = "PATCH";
  final deleteRequestType = "DELETE";

  databaseRequest(String link, String type,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      headers ??= {};
      print(link);
      print(type);
      var request = http.Request(type, Uri.parse(link));
      if (body != null) {
        request.body = json.encode(body);
      }
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      return response.stream.bytesToString();
    } catch (e) {
      print(e);
    }
  }
}
