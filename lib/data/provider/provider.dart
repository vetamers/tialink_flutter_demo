import 'package:auth/auth.dart';

abstract class DataProvider {
  late HttpHelper http;

  DataProvider(this.http) {
    http.authorizationToken = Authenticator.instance.token!;
  }
}
