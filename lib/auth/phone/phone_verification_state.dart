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

class PhoneVerificationTryCredential extends PhoneVerificationState{
  final PhoneAuthCredential credential;

  PhoneVerificationTryCredential(this.credential);
}

class PhoneVerificationInvalidCredential extends PhoneVerificationState{
  final APIException error;

  PhoneVerificationInvalidCredential(this.error);
}

class PhoneVerificationDone extends PhoneVerificationState {
  final AuthResult authResult;

  PhoneVerificationDone(this.authResult);
}

