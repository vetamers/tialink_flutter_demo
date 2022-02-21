import 'dart:convert';
import 'dart:io';

import 'package:auth/core/api_error.dart';
import 'package:auth/core/credential.dart';
import 'package:auth/core/network.dart';

class AuthService {
  final HttpHelper _httpHelper = HttpHelper("auth/");

  Future<String> getToken(AuthCredential credential) async {
    Response response = await _httpHelper.post("token", <String,dynamic>{"credential":credential.toJson(),"tokenName":"Dart"});

    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body)["token"].toString();
    } else {
      return Future.error(APIException(response.statusCode, response.body));
    }
  }
}
