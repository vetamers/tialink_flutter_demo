import 'dart:convert';
import 'dart:developer';

import 'package:auth/core/api_error.dart';
import 'package:auth/core/network.dart';
import 'package:auth/model/phone_verification.dart';
import 'package:auth/model/user.dart';
import 'package:auth/service/phone_service.dart';
import 'package:auth/service/user_service.dart';

class UserProvider {
  final String authToken;
  late final UserService _service;

  UserProvider(this.authToken) {
    _service = UserService(authToken);
  }

  Future<User> getUser() async {
    Response response = await _service.getUser();

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(APIException(response.statusCode, response.body));
    }
  }
}
