import 'package:dio/dio.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';

abstract class AuthRemoteSource {
  Future<PhoneAuthRequestModel> requestPhoneVerification(String phone);
  Future<AuthResult> createToken(AuthCredential credential,String deviceName);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final Dio dio;

  AuthRemoteSourceImpl(this.dio);

  @override
  Future<PhoneAuthRequestModel> requestPhoneVerification(String phone) async {
    var response = await dio.post("auth/provider/phone/request",data: {"phone": phone});

    if (response.statusCode == 201){
      return PhoneAuthRequestModel.fromJson(response.data);
    }else{
      throw APIException.from(response);
    }
  }

  @override
  Future<AuthResult> createToken(AuthCredential credential,String deviceName) async {
    var response = await dio.post("auth/token",data: {"credential": credential.toJson(),"deviceName": deviceName});

    if (response.statusCode == 200){
      return AuthResult.fromJson(response.data);
    }else{
      throw APIException.from(response);
    }
  }
}