import 'package:dartz/dartz.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/core/usecases/usecase.dart';
import 'package:tialink/features/auth/domain/entities/auth_phones_entities.dart';
import 'package:tialink/features/auth/domain/repositories/auth_repository.dart';

class RequestPhoneAuth extends UseCase<PhoneAuthRequest,APIException,RequestPhoneAuthParams>{
  final AuthRepository _repository;

  RequestPhoneAuth(this._repository);

  @override
  Future<Either<PhoneAuthRequest, APIException>> call(RequestPhoneAuthParams param) {
    return _repository.requestPhoneVerification(param.phone);
  }

}

class RequestPhoneAuthParams extends UseCaseParam {
  final String phone;

  RequestPhoneAuthParams(this.phone);

  @override
  Map<String, dynamic> get fields => {"phone": phone};

  @override
  List<Object?> get props => [phone];
}