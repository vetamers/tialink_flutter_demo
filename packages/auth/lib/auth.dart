library auth;

import 'package:auth/model/phone_verification.dart';
import 'package:auth/service/auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'providers/phone_auth.dart';
export 'model/phone_verification.dart';
export 'utils.dart';

class Authenticator {
  static Authenticator instance = Authenticator();

  void initAuthenticationPackage() async {
    await Hive.openBox("auth");
  }
}
