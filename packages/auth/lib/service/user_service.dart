import 'package:auth/core/network.dart';
import 'package:auth/core/service.dart';

class UserService extends APIService {
  UserService(String authToken) : super(HttpHelper("")) {
    httpHelper.authorizationToken = authToken;
  }

  Future<Response> getUser() async {
    return await httpHelper.get("user");
  }
}
