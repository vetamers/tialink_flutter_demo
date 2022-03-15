import 'package:equatable/equatable.dart';

abstract class PhoneAuthRequest extends Equatable {
  final String requestId;
  final String resendToken;
  final int expireIn;

  const PhoneAuthRequest(this.requestId, this.resendToken, this.expireIn);

  @override
  List<Object?> get props => [requestId];
}

