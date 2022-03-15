import 'package:flutter/foundation.dart';

abstract class AuthException extends ErrorDescription {
  final String message;
  AuthException(this.message) : super(message);

  @override
  bool operator ==(Object other) => other is AuthException && other.hashCode == hashCode;

  @override
  int get hashCode => message.hashCode;
}

class AuthInvalidUserException extends AuthException {
  static const _errorUserTokenNotFound = "ERROR_USER_TOKEN_NOT_FOUND";
  static const _errorUserTokenExpire = "ERROR_USER_TOKEN_EXPIRE";

  final String code;

  AuthInvalidUserException._(this.code) : super("Code: $code");

  factory AuthInvalidUserException.errorUserTokenNotFound() =>
      AuthInvalidUserException._(_errorUserTokenNotFound);

  factory AuthInvalidUserException.errorUserTokenExpire() =>
      AuthInvalidUserException._(_errorUserTokenExpire);
}
