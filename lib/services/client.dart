import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class DbBase {
  final postRequestType = "POST";
  final getRequestType = "GET";
  final putRequestType = "PUT";
  final patchRequestType = "PATCH";
  final deleteRequestType = "DELETE";

  databaseRequest(String link, String type,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? token = prefs.getString("token");
      String? token =
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjYzZjllZmUzODc5ZTE2ODAxMDU0YTBiMCIsIm5hbWUiOiJwZXRlciBLaW1hbmkiLCJlbWFpbCI6InBldGVya2lyb25qaThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMDUkUGhnZ09vUmhabGFRREVWQnUzR2FLdTJGVHlsVXRpb1oxdk9uWHhaS1psV1JpMjNrQkpXTHkiLCJwaG9uZW51bWJlciI6IjA3ODIwMTU2NjAiLCJzaG9wcyI6W3siX2lkIjoiNjQyMmU4OGUyZjczNTQ1ZThkZWJkOWI1IiwibmFtZSI6Im5ld2plcnNleXMiLCJsb2NhdGlvbiI6Im5ha3VydSIsIm93bmVyIjoiNjNmOWVmZTM4NzllMTY4MDEwNTRhMGIwIiwidHlwZSI6ImNvbW1lcmNlIiwiY3VycmVuY3kiOiJBRUQiLCJjcmVhdGVkQXQiOiIyMDIzLTAzLTI4VDEzOjE1OjU4LjMxNFoiLCJ1cGRhdGVkQXQiOiIyMDIzLTAzLTI5VDEzOjIzOjIzLjQ1NFoiLCJfX3YiOjB9XSwiY3JlYXRlZEF0IjoiMjAyMy0wMi0yNVQxMToyNDoxOS42NjRaIiwidXBkYXRlZEF0IjoiMjAyMy0wMy0yOFQxMzoxNTo1OC4zMTZaIiwiX192IjowLCJhdHRlbmRhbnRpZCI6IjYzZjllZmUzODc5ZTE2ODAxMDU0YTBiMCJ9LCJpYXQiOjE2ODIzMjMzNjIsImV4cCI6MTY4NDkxNTM2Mn0.03O2gB3O1jsNmpc7tdJ42z5cQspGe3x1XJuLIkYjTAE";
      headers ??= {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token ?? ""}",
      };

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
