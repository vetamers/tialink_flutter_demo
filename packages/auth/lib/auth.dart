library auth;

import 'package:auth/core/api_error.dart';
import 'package:auth/core/credential.dart';
import 'package:auth/model/api_result.dart';
import 'package:auth/providers/user_provider.dart';
import 'package:auth/service/auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'providers/phone_auth.dart';
export 'model/phone_verification.dart';
export 'utils.dart';

class Authenticator {
  static Authenticator instance = Authenticator();
  final _authService = AuthService();
  late UserProvider _userProvider;

  void initAuthenticationPackage() async {
    await Hive.openBox("auth");
  }

  Future<AuthResult> signInWithCredential(AuthCredential credential) async {
    try {
      String token = await _authService.getToken(credential);
      _userProvider = UserProvider(token);

      Hive.box("auth").put("token", token);

      return AuthResult(await _userProvider.getUser());
    } on APIException catch (e) {
      return Future.error(e);
    }
  }
}
