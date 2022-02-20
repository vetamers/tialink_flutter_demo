part of 'phone_verification_bloc.dart';

@immutable
abstract class PhoneVerificationState {}

class PhoneVerificationInitial extends PhoneVerificationState {}

class PhoneVerificationRequested extends PhoneVerificationState {
  final PhoneVerificationRequest verificationRequest;

  PhoneVerificationRequested(this.verificationRequest);
}

class PhoneVerificationRequestError extends PhoneVerificationState{
  final APIException error;
  final PhoneVerificationRequestEvent event;

  PhoneVerificationRequestError(this.error, this.event);
}

class PhoneVerificationCodeValid extends PhoneVerificationState {
  final PhoneAuthCredential credential;

  PhoneVerificationCodeValid(this.credential);
}

class PhoneVerificationInvalidCode extends PhoneVerificationState {
  final APIException error;

  PhoneVerificationInvalidCode(this.error);
}

