import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/exceptions/auth_exceptions.dart';

abstract class AuthLocalSource {
  AuthResult getAuthCertificate();

  Future<void> saveAuthCertificate(AuthResult authResult);
}

class AuthLocalSourceImpl implements AuthLocalSource {
  final Box box;

  AuthLocalSourceImpl(this.box);

  @override
  AuthResult getAuthCertificate() {
    if (box.containsKey("certificate")) {
      var certificate = AuthResult.fromJson(jsonDecode(box.get("certificate")));
      if (certificate.expireAt.isAfter(DateTime.now())) {
        return certificate;
      } else {
        throw AuthInvalidUserException.errorUserTokenExpire();
      }
    } else {
      throw AuthInvalidUserException.errorUserTokenNotFound();
    }
  }

  @override
  Future<void> saveAuthCertificate(AuthResult authResult) {
    return box.put("certificate", jsonEncode(authResult.toJson()));
  }
}
