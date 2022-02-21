import 'dart:convert';
import 'dart:io';

import 'package:auth/core/api_error.dart';
import 'package:auth/core/network.dart';
import 'package:auth/core/service.dart';
import 'package:auth/model/phone_verification.dart';
import 'package:http/http.dart';

class PhoneService extends APIService {
  PhoneService() : super(HttpHelper("auth/provider/phone/"));

  Future<PhoneVerificationRequest> requestVerify(String phone) async {
    Response response = await httpHelper.post("request", {"phone": phone});

    if (response.statusCode == HttpStatus.created) {
      return PhoneVerificationRequest.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(APIException(response.statusCode, response.body));
    }
  }
}
