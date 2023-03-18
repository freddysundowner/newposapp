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
      String? token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjYzZjllZmUzODc5ZTE2ODAxMDU0YTBiMCIsIm5hbWUiOiJwZXRlciBLaW1hbmkiLCJlbWFpbCI6InBldGVya2lyb25qaThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMDUkUnJ5Zmk2Rjh4VVNxSFpDeVBUcWxBLlNQalBmYnNYVk55YmtBNWN0T05CSU1UeFlZV09tTkMiLCJwaG9uZW51bWJlciI6IjA3ODIwMTU2NjAiLCJzaG9wcyI6W3siX2lkIjoiNjNmYTA4OWU0NjcyMWI3NDgwNDc0YmU1IiwibmFtZSI6ImFwcGxlIiwibG9jYXRpb24iOiJuYWt1cnUiLCJvd25lciI6IjYzZjllZmUzODc5ZTE2ODAxMDU0YTBiMCIsInR5cGUiOiJlbGVjdHJvbmljcyIsImN1cnJlbmN5IjoiQVJTIiwiY3JlYXRlZEF0IjoiMjAyMy0wMi0yNVQxMzowOTo1MC44MDFaIiwidXBkYXRlZEF0IjoiMjAyMy0wMi0yN1QxMDo1Mzo0Ni4wMTJaIiwiX192IjowfV0sImNyZWF0ZWRBdCI6IjIwMjMtMDItMjVUMTE6MjQ6MTkuNjY0WiIsInVwZGF0ZWRBdCI6IjIwMjMtMDMtMTZUMDY6Mjc6MzQuMDI1WiIsIl9fdiI6MCwiYXR0ZW5kYW50aWQiOiI2M2Y5ZWZlMzg3OWUxNjgwMTA1NGEwYjAifSwiaWF0IjoxNjc5MTMyNTgyLCJleHAiOjE2ODE3MjQ1ODJ9.jyejpZjJyNlu2JDl6OW9AGAndQJt-piuxtF1fyJeFls";
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
