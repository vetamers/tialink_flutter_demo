import 'package:auth/core/credential.dart';
import 'package:auth/providers/phone_auth.dart';
import 'package:equatable/equatable.dart';

class PhoneVerificationRequest extends Equatable {
  final String id;
  final String resendToken;
  final int expireIn;

  const PhoneVerificationRequest(this.id, this.resendToken, this.expireIn);

  factory PhoneVerificationRequest.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationRequest(
        json["id"], json["resend_token"], json["expire_in"]);
  }

  @override
  List<Object?> get props => [id, resendToken, expireIn];
}

class PhoneAuthCredential extends AuthCredential {
  final String credentialToken;
  final int expireIn;

  const PhoneAuthCredential(this.credentialToken, this.expireIn) : super(PhoneAuthProvider.providerId,PhoneAuthProvider.signInMethod);

  factory PhoneAuthCredential.fromJson(Map<String, dynamic> json) {
    return PhoneAuthCredential(json["credential"], json["expire_in"]);
  }
}
