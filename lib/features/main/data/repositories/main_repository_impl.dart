import 'package:tialink/core/exceptions/main_exceptions.dart';
import 'package:tialink/features/main/data/datasources/main_localsource.dart';
import 'package:tialink/features/main/data/datasources/main_remotesource.dart';
import 'package:tialink/features/main/data/model/main_models.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';
import 'package:tialink/features/main/domain/entities/api_entity.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';

import '../../domain/repositories/main_repository.dart';

class MainRepositoryImpl implements MainRepository {
  final MainLocalSource _localSource;
  final MainRemoteSource _remoteSource;

  MainRepositoryImpl(this._localSource, this._remoteSource);

  @override
  Future<Either<List<Home>, APIException>> getHomes([DataSource source = DataSource.local]) async {
    if (source == DataSource.local){
      try {
        return left(_localSource.getModels<Home>(fromJson: HomeModel.fromJson));
      } on CacheEmptyException {
        try {
          var result = await _remoteSource.getHomes();
          _localSource.putModels<HomeModel>(result, uuid: (o) => o.uuid, toJson: (o) => o.toJson());
          return left(result);
        } on APIException catch (e) {
          return right(e);
        }
      }
    }else{
      try {
        var result = await _remoteSource.getHomes();
        _localSource.putModels<HomeModel>(result, uuid: (o) => o.uuid, toJson: (o) => o.toJson());
        return left(result);
      } on APIException catch (e) {
        return right(e);
      }
    }
  }

  @override
  Future<Either<APIResult, APIException>> addHome(
      {required String label,
      String? deviceId,
      String? deviceMacAddress,
      String? deviceSecret,
      String? doorLabel,
      int? doorButtonMode}) async {
    // assert(deviceId != null &&
    //     deviceMacAddress == null &&
    //     deviceSecret == null &&
    //     doorLabel == null &&
    //     doorButtonMode == null);
    // assert(deviceId == null &&
    //     deviceMacAddress != null &&
    //     deviceSecret != null &&
    //     doorLabel != null &&
    //     doorButtonMode != null);

    if (deviceId != null) {
      return left(await _remoteSource.addHome(label: label, deviceId: deviceId));
    } else {
      return left(await _remoteSource.addFirstHome(
          label: label,
          deviceMacAddress: deviceMacAddress!,
          deviceSecret: deviceSecret!,
          doorLabel: doorLabel!,
          buttonMode: doorButtonMode!));
    }
  }

  @override
  Future<Either<Home, APIException>> getHome(String id,[DataSource source = DataSource.local]) async {
    try {
      return left(_localSource.getModel<Home>(id, fromJson: HomeModel.fromJson));
    } on CacheMissException {
      try {
        var result = await _remoteSource.getHome(id);
        _localSource.putModel<HomeModel>(result, uuid: (o) => o.uuid, toJson: (o) => o.toJson());
        return left(result);
      } on APIException catch (e) {
        return right(e);
      }
    }
  }

  @override
  Future<Either<APIResult, APIException>> updateHome(Home home) async {
    try{
      return left(await _remoteSource.editHome(home: home));
    }on APIException catch(e) {
      return right(e);
    }
  }

  @override
  Future<Either<APIResult, APIException>> addDoor(AddDoorParam param) async {
    try {
      return left(await _remoteSource.addDoor(homeId: param.homeId, doorLabel: param.doorLabel, buttonMode: param.doorButtonMode));
    }on APIException catch(e){
      return right(e);
    }
  }
}
