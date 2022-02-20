import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

final Map<String, String> baseHeader = {
  HttpHeaders.acceptHeader: "application/json"
};

const String baseUrl = "http://192.168.1.192:8000";

String getAPIUrl({int version = 2}) => "$baseUrl/api/v$version/";

Future<Response> postJson(String url, dynamic data) async {
  Client client = Client();
  return client.post(Uri.parse(url),
      headers: baseHeader, body: data, encoding: Encoding.getByName("UTF8"));
}
