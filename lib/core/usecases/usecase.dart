import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';

abstract class UseCase<T,P extends UseCaseParam> {
  Future<Either<T, APIException>> call(P param);
}

abstract class UseCaseParam extends Equatable {
  Map<String, dynamic> get fields;
}

class NoParam extends UseCaseParam {
  @override
  Map<String, dynamic> get fields => {};

  @override
  List<Object?> get props => [];
}
