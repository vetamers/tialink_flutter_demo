import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';
export 'package:http/http.dart';

class HttpHelper {
  final Client _client = Client();
  final String _baseUrl = "http://192.168.1.192:8000";
  final String _serviceUrl;
  String get apiUrl => "$_baseUrl/api/v$apiVersion/$_serviceUrl";
  int apiVersion = 2;

  final Map<String, String> _baseHeader = {
    HttpHeaders.contentTypeHeader: "application/json; charset=utf-8",
    HttpHeaders.acceptHeader: "application/json"
  };

  HttpHelper(this._serviceUrl);

  set authorizationToken(String? token) {
    if (token != null) {
      _baseHeader.addAll({HttpHeaders.authorizationHeader: "Bearer $token"});
    } else {
      if (_baseHeader.containsKey(HttpHeaders.authorizationHeader)) {
        _baseHeader.remove(HttpHeaders.authorizationHeader);
      }
    }
  }

  Future<Response> get(String route) async =>
      _client.get(Uri.parse(apiUrl + route), headers: _baseHeader);

  Future<Response> post(String route, dynamic body) async => _client
      .post(Uri.parse(apiUrl + route), body: jsonEncode(body), headers: _baseHeader);
}
