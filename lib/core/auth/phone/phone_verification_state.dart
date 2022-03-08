part of 'phone_verification_bloc.dart';

enum PhoneVerificationStatus { initial, requested, requestError, tryCredential, invalidCredential, done }

class PhoneVerificationState extends Equatable {
  final PhoneVerificationStatus value;
  final Map<String, dynamic> metadata;

  const PhoneVerificationState(this.value, [this.metadata = const {}]);

  factory PhoneVerificationState.initial() => const PhoneVerificationState(PhoneVerificationStatus.initial, {});

  factory PhoneVerificationState.requested(PhoneVerificationRequest request) =>
      PhoneVerificationState(PhoneVerificationStatus.requested, {"request": request});

  factory PhoneVerificationState.error(APIException error, PhoneVerificationEvent event) =>
      PhoneVerificationState(PhoneVerificationStatus.requestError, {"error": error, "event": event});

  factory PhoneVerificationState.tryCredential(PhoneAuthCredential credential) =>
      PhoneVerificationState(PhoneVerificationStatus.tryCredential, {"credential": credential});

  factory PhoneVerificationState.invalidCredential(APIException error) =>
      PhoneVerificationState(PhoneVerificationStatus.invalidCredential, {"error": error});

  factory PhoneVerificationState.done(AuthResult result) =>
      PhoneVerificationState(PhoneVerificationStatus.done, {"result": result});

  @override
  List<Object?> get props => [value, metadata];
}
