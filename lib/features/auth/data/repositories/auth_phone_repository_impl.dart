import 'package:dartz/dartz.dart';
import 'package:tialink/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/exceptions/auth_exceptions.dart';

import '../../../../core/exceptions/api_exceptions.dart';
import '../../domain/entities/auth_phones_entities.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteDataSource;
  final AuthLocalSource localSource;

  AuthRepositoryImpl(this.remoteDataSource,this.localSource);

  @override
  Future<Either<PhoneAuthRequest, APIException>> requestPhoneVerification(String phone) async {
    try{
      var response = await remoteDataSource.requestPhoneVerification(phone);
      return Left(response);
    }on APIException catch(e){
      return Right(e);
    }catch (e){
      return Future.error(e);
    }
  }

  @override
  Future<Either<AuthResult, APIException>> createToken(AuthCredential credential,String deviceName) async {
    try{
      var response = await remoteDataSource.createToken(credential,deviceName);
      await localSource.saveAuthCertificate(response);
      return Left(response);
    }on APIException catch(e){
      return Right(e);
    }catch(e){
      return Future.error(e);
    }
  }

  @override
  Either<AuthResult, AuthException> getToken() {
    try{
      return Left(localSource.getAuthCertificate());
    }on AuthException catch (e) {
      return Right(e);
    }
  }

}