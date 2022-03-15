import 'package:dartz/dartz.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/core/usecases/usecase.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/domain/repositories/auth_repository.dart';

class LoginWithCredential extends UseCase<AuthResult,LoginParam> {
  final AuthRepository repository;

  LoginWithCredential(this.repository);

  @override
  Future<Either<AuthResult, APIException>> call(LoginParam param) {
    return repository.createToken(param.credential,param.deviceName);
  }
}

class LoginParam extends UseCaseParam {
  final AuthCredential credential;
  final String deviceName;

  LoginParam(this.credential,this.deviceName);

  @override
  Map<String, dynamic> get fields => {"credential": credential,"deviceName": deviceName};

  @override
  List<Object?> get props => [credential,deviceName];

}