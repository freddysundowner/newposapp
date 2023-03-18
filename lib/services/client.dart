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
      String? token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjp7Il9pZCI6IjYzZjllZmUzODc5ZTE2ODAxMDU0YTBiMCIsIm5hbWUiOiJwZXRlcktpbXUiLCJlbWFpbCI6InBldGVya2lyb25qaThAZ21haWwuY29tIiwicGFzc3dvcmQiOiIkMmIkMDUkWkg2T0wwU0IvNVliWFdRQkJKbXJNdW1acWg0VTdybzBLN3VYSHVKM0xPdktGSGlXVnUveG0iLCJwaG9uZW51bWJlciI6IjA3ODIwMTU2NjAiLCJzaG9wcyI6W3siX2lkIjoiNjNmYTA4OWU0NjcyMWI3NDgwNDc0YmU1IiwibmFtZSI6ImFwcGxlIiwibG9jYXRpb24iOiJuYWt1cnUiLCJvd25lciI6IjYzZjllZmUzODc5ZTE2ODAxMDU0YTBiMCIsInR5cGUiOiJlbGVjdHJvbmljcyIsImN1cnJlbmN5IjoiQVJTIiwiY3JlYXRlZEF0IjoiMjAyMy0wMi0yNVQxMzowOTo1MC44MDFaIiwidXBkYXRlZEF0IjoiMjAyMy0wMi0yN1QxMDo1Mzo0Ni4wMTJaIiwiX192IjowfSx7Il9pZCI6IjYzZmEwOGJjNDY3MjFiNzQ4MDQ3NGJlZSIsIm5hbWUiOiJraW0iLCJsb2NhdGlvbiI6Im5haXZhc2hhIiwib3duZXIiOiI2M2Y5ZWZlMzg3OWUxNjgwMTA1NGEwYjAiLCJ0eXBlIjoiZWxlIiwiY3VycmVuY3kiOiJCRFQiLCJjcmVhdGVkQXQiOiIyMDIzLTAyLTI1VDEzOjEwOjIwLjcyMVoiLCJ1cGRhdGVkQXQiOiIyMDIzLTAyLTI3VDEwOjUzOjI0LjcyMVoiLCJfX3YiOjB9LHsiX2lkIjoiNjNmZjUxMzA4YjY1OGFhZmJmNGUzNTM3IiwibmFtZSI6ImFwcGxlU2hvcCIsImxvY2F0aW9uIjoibmFrdXJ1Iiwib3duZXIiOiI2M2Y5ZWZlMzg3OWUxNjgwMTA1NGEwYjAiLCJ0eXBlIjoiZWxlY3Ryb25pY3MiLCJjdXJyZW5jeSI6IlVTRCIsImNyZWF0ZWRBdCI6IjIwMjMtMDMtMDFUMTM6MjA6NDguODg1WiIsInVwZGF0ZWRBdCI6IjIwMjMtMDMtMDFUMTM6MjA6NDguODg1WiIsIl9fdiI6MH1dLCJjcmVhdGVkQXQiOiIyMDIzLTAyLTI1VDExOjI0OjE5LjY2NFoiLCJ1cGRhdGVkQXQiOiIyMDIzLTAzLTAxVDEzOjIwOjQ4Ljg4N1oiLCJfX3YiOjAsImF0dGVuZGFudGlkIjoiNjNmOWVmZTM4NzllMTY4MDEwNTRhMGIwIn0sImlhdCI6MTY3ODg2NTA1NywiZXhwIjoxNjgxNDU3MDU3fQ.wnurftWOXukJmqPPJd4Et8-lnvIYQgbPdoDoH82M0Jg";

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
