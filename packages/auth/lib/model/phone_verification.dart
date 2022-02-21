import 'dart:convert';

import 'package:auth/core/credential.dart';
import 'package:auth/providers/phone_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'phone_verification.g.dart';

@JsonSerializable()
class PhoneVerificationRequest{
  late String id;
  @JsonKey(name: "resend_token")
  late String resendToken;

  @JsonKey(name: "expire_in")
  late int expireIn;

  PhoneVerificationRequest();

  factory PhoneVerificationRequest.fromJson(Map<String,dynamic> json) => _$PhoneVerificationRequestFromJson(json);
}

@JsonSerializable(createFactory: false,ignoreUnannotated: true)
class PhoneAuthCredential extends AuthCredential {

  final String verificationId;
  final String smsCode;

  PhoneAuthCredential(this.verificationId,this.smsCode);

  @JsonKey()
  @override
  String get providerId => PhoneAuthProvider.providerId;

  @JsonKey()
  @override
  String get signInMethod => PhoneAuthProvider.signInMethod;

  @JsonKey()
  @override
  Map<String, String> get payload =>
      {"verificationId": verificationId, "smsCode": smsCode};

  Map<String,dynamic> toJson() => _$PhoneAuthCredentialToJson(this);

}
