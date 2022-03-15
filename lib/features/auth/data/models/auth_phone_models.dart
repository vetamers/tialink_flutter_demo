import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/domain/entities/auth_phones_entities.dart';

part 'auth_phone_models.g.dart';

@JsonSerializable(constructor: '_')
class PhoneAuthRequestModel extends PhoneAuthRequest{
  final String id;
  @JsonKey(name: "resend_token")
  final String token;

  @JsonKey(name: "expire_in")
  final int expire;

  const PhoneAuthRequestModel._(this.id, this.token, this.expire) : super(id,token,expire);

  factory PhoneAuthRequestModel.fromJson(Map<String,dynamic> json) => _$PhoneAuthRequestModelFromJson(json);

  Map<String,dynamic> toJson() => _$PhoneAuthRequestModelToJson(this);

  @visibleForTesting
  static PhoneAuthRequestModel fake() {
    return const PhoneAuthRequestModel._("requestId", "resendToken", 1);
  }
}

@JsonSerializable(createFactory: false,ignoreUnannotated: true)
class PhoneAuthCredentialModel extends AuthCredential {
  final String verificationId;
  final String smsCode;

  PhoneAuthCredentialModel(this.verificationId, this.smsCode);

  @JsonKey()
  @override
  String get providerId => "phone";

  @JsonKey()
  @override
  String get signInMethod => "phone";

  @JsonKey()
  @override
  Map<String, dynamic> get payload => {
    "verificationId": verificationId,
    "smsCode": smsCode
  };

  @override
  Map<String, dynamic> toJson() => _$PhoneAuthCredentialModelToJson(this);
}