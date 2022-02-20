import 'dart:convert';
import 'dart:io';

import 'package:auth/core/api_error.dart';
import 'package:auth/core/network.dart';
import 'package:auth/model/phone_verification.dart';
import 'package:http/http.dart';

class PhoneService {
  final String _url = getAPIUrl() + "auth/provider/phone/";

  Future<PhoneVerificationRequest> requestVerify(String phone) async {
    Response response = await postJson(_url + "request", {"phone": phone});

    if (response.statusCode == HttpStatus.created) {
      return PhoneVerificationRequest.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(APIException(response.statusCode, response.body));
    }
  }

  Future<PhoneAuthCredential> getCredential(
      String verificationId, int smsCode) async {
    Response response = await postJson(
        _url + "credential", {"id": verificationId, "code": "$smsCode"});

    if (response.statusCode == HttpStatus.ok) {
      return PhoneAuthCredential.fromJson(jsonDecode(response.body));
    } else {
      return Future.error(APIException(response.statusCode, response.body));
    }
  }
}
