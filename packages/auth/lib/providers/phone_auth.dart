import 'dart:developer';

import 'package:auth/core/api_error.dart';
import 'package:auth/model/phone_verification.dart';
import 'package:auth/service/phone_service.dart';

class PhoneAuthProvider {
  static const String providerId = "phone";
  static const String signInMethod = "phone";

  final PhoneService _service = PhoneService();

  PhoneAuthProvider();

  Future<PhoneVerificationRequest> verificationRequest(String phone) async{
    return _service.requestVerify(phone);
  }

   PhoneAuthCredential getCredential(String verificationId, String smdCode) =>
      PhoneAuthCredential(verificationId, smdCode);
}
