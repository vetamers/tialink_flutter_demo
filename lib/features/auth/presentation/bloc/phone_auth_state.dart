part of 'phone_auth_bloc.dart';

enum PhoneAuthStatus {
  initial,
  loading,
  requested,
  requestFailed,
  invalidCredential,
  tooManyFailedAttempt,
  credentialAccept
}

class PhoneAuthState extends Equatable {
  final PhoneAuthStatus value;
  final Map<String,dynamic> metadata;

  @override
  List<Object?> get props => [value,metadata];

  const PhoneAuthState._(this.value, [this.metadata = const {}]);

  factory PhoneAuthState.initial() => const PhoneAuthState._(PhoneAuthStatus.initial);
  factory PhoneAuthState.loading(PhoneAuthEvent event) => PhoneAuthState._(PhoneAuthStatus.loading,{"event": event});
  factory PhoneAuthState.requested(PhoneAuthRequest authRequest) => PhoneAuthState._(PhoneAuthStatus.requested,{"request": authRequest});
  factory PhoneAuthState.requestFailed(APIException exception) => PhoneAuthState._(PhoneAuthStatus.requestFailed,{"exception": exception});
  factory PhoneAuthState.invalidCredential(PhoneAuthEvent event) => PhoneAuthState._(PhoneAuthStatus.requestFailed,{"event": event});
  factory PhoneAuthState.tooManyFailedAttempt() => const PhoneAuthState._(PhoneAuthStatus.tooManyFailedAttempt);
  factory PhoneAuthState.credentialAccept() => const PhoneAuthState._(PhoneAuthStatus.credentialAccept);

}

