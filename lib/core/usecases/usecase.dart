import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<L,R,P extends UseCaseParam> {
  //TODO: Add repository getter

  Future<Either<L,R>> call(P param);
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
