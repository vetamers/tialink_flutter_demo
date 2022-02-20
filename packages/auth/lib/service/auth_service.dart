import 'dart:convert';
import 'dart:io';

import 'package:auth/core/api_error.dart';
import 'package:auth/core/credential.dart';
import 'package:auth/core/network.dart';
import 'package:http/http.dart';

class AuthService {
  final String _url = getAPIUrl() + "auth/";

  Future<String> getToken(AuthCredential credential) async{
      Response response = await postJson(_url + "token", {"credential":credential.signInMethod,"device_name":"TEST"});

      if (response.statusCode == HttpStatus.ok){
        return jsonDecode(response.body)["token"].toString();
      }else{
        return Future.error(APIException(response.statusCode,response.body));
      }
  }
}