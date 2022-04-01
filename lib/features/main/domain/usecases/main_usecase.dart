import 'package:dartz/dartz.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/core/usecases/usecase.dart';
import 'package:tialink/features/main/domain/entities/api_entity.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';
import 'package:tialink/features/main/domain/repositories/main_repository.dart';

class GetHomes extends UseCase<dynamic, APIException, GetHomeParam> {
  final MainRepository _repository;

  GetHomes(this._repository);

  @override
  Future<Either<dynamic, APIException>> call(GetHomeParam param) {
    if (param.id == null) {
      return _repository.getHomes(param.source);
    } else {
      return _repository.getHome(param.id!,param.source);
    }
  }
}

class GetHomeParam extends UseCaseParam {
  final String? id;
  final DataSource source;

  GetHomeParam([this.id,this.source = DataSource.local]);

  @override
  Map<String, dynamic> get fields => id != null ? {"id": id} : {};

  @override
  List<Object?> get props => [id];
}

class AddHomeParam extends UseCaseParam {
  final String label;
  final String? deviceId;
  final String? deviceMacAddress;
  final String? deviceSecret;
  final String? doorLabel;
  final int? doorButtonMode;

  bool get isFull => deviceId == null;

  AddHomeParam._(this.label,
      [this.deviceId, this.deviceMacAddress, this.deviceSecret, this.doorLabel, this.doorButtonMode]);

  factory AddHomeParam.normal(String label, String deviceId) => AddHomeParam._(label, deviceId);
  factory AddHomeParam.full(
          String label, String deviceMacAddress, String deviceSecret, String doorLabel, int doorButtonMode) =>
      AddHomeParam._(label, null, deviceMacAddress, deviceSecret, doorLabel, doorButtonMode);

  @override
  Map<String, dynamic> get fields => {}; //TODO: fill this

  @override
  List<Object?> get props => [label, isFull ? "full" : "normal"];
}

class AddHome extends UseCase<APIResult, APIException, AddHomeParam> {
  final MainRepository _repository;

  AddHome(this._repository);

  @override
  Future<Either<APIResult, APIException>> call(AddHomeParam param) {
    if (param.isFull) {
      return _repository.addHome(
          label: param.label,
          deviceMacAddress: param.deviceMacAddress,
          deviceSecret: param.deviceSecret,
          doorLabel: param.doorLabel,
          doorButtonMode: param.doorButtonMode);
    } else {
      return _repository.addHome(label: param.label, deviceId: param.deviceId);
    }
  }
}

class UpdateHomeParam extends UseCaseParam {
  final Home home;

  UpdateHomeParam(this.home);

  @override
  Map<String, dynamic> get fields => throw UnimplementedError();

  @override
  List<Object?> get props => [home];
}

class UpdateHome extends UseCase<APIResult,APIException,UpdateHomeParam> {
  final MainRepository _repository;

  UpdateHome(this._repository);

  @override
  Future<Either<APIResult, APIException>> call(UpdateHomeParam param) {
    return _repository.updateHome(param.home);
  }

}