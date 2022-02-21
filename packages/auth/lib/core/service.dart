import 'package:auth/core/network.dart';

abstract class APIService {
  final HttpHelper httpHelper;

  APIService(this.httpHelper);
}
