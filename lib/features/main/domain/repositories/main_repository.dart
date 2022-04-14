import 'package:dartz/dartz.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/main/domain/entities/api_entity.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';
import 'package:tialink/features/main/domain/usecases/main_usecase.dart';

abstract class MainRepository {
  Future<Either<Home, APIException>> getHome(String id,[DataSource source = DataSource.local]);
  Future<Either<List<Home>, APIException>> getHomes([DataSource source = DataSource.local]);

  /// Adding new home
  ///
  /// if deviceId is null should fill all other field
  Future<Either<APIResult, APIException>> addHome({
    required String label,
    String? deviceId,
    String? deviceMacAddress,
    String? deviceSecret,
    String? doorLabel,
    int? doorButtonMode,
  });

  Future<Either<APIResult,APIException>> updateHome(Home home);

  Future<Either<APIResult,APIException>> addDoor(AddDoorParam param);
}
