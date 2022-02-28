part of 'phone_verification_bloc.dart';

@immutable
abstract class PhoneVerificationEvent {}

class PhoneVerificationRequestEvent extends PhoneVerificationEvent {
  final String phone;

  PhoneVerificationRequestEvent(this.phone);
}

class PhoneVerificationTryCodeEvent extends PhoneVerificationEvent {
  final String verificationId;
  final String smsCode;

  PhoneVerificationTryCodeEvent(this.verificationId, this.smsCode);
}

class PhoneVerificationResendCodeEvent extends PhoneVerificationEvent {
  final String resendToken;

  PhoneVerificationResendCodeEvent(this.resendToken);
}
