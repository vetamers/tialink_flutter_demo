import 'package:dartz/dartz.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/exceptions/auth_exceptions.dart';

import '../entities/auth_phones_entities.dart';

abstract class AuthRepository {
  Future<Either<PhoneAuthRequest,APIException>> requestPhoneVerification(String phone);
  Future<Either<AuthResult,APIException>> createToken(AuthCredential credential,String deviceName);
  Either<AuthResult,AuthException> getToken();

}
