part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();
}

class PhoneAuthRequestEvent extends PhoneAuthEvent {
  final RequestPhoneAuthParams params;

  const PhoneAuthRequestEvent(this.params);

  @override
  List<Object?> get props => [params];
}

class PhoneAuthTryCredential extends PhoneAuthEvent {
  final PhoneAuthRequest authRequest;
  final String smsCode;

  const PhoneAuthTryCredential(this.authRequest, this.smsCode);

  @override
  List<Object?> get props => [smsCode];
}
