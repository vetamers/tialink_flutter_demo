import 'package:equatable/equatable.dart';

class AuthCredential extends Equatable {
  final String providerId;
  final String signInMethod;

  const AuthCredential(this.providerId, this.signInMethod);

  @override
  List<Object?> get props => [providerId, signInMethod];
}

