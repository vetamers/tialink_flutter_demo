import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/core/usecases/usecase.dart';
import 'package:tialink/features/bluetooth/domain/repositories/bluetooth_repository.dart';

class FindDeviceByAddress
    extends UseCase<BluetoothDiscoveryResult, BluetoothTargetNotFound, FindDeviceParam> {
  final BluetoothRepository _repository;

  FindDeviceByAddress(this._repository);

  @override
  Future<Either<BluetoothDiscoveryResult, BluetoothTargetNotFound>> call(FindDeviceParam param) {
    assert(param.address != null);
    return _repository.findTiaLinkDeviceWithAddress(param.address!);
  }
}

class FindDeviceByName extends UseCase<BluetoothDiscoveryResult, BluetoothTargetNotFound, FindDeviceParam> {
  final BluetoothRepository _repository;

  FindDeviceByName(this._repository);

  @override
  Future<Either<BluetoothDiscoveryResult, BluetoothTargetNotFound>> call(FindDeviceParam param) {
    assert(param.name != null);
    return _repository.findTiaLinkDeviceWithName(param.name!);
  }
}

class FindDeviceParam extends UseCaseParam {
  String? address;
  String? name;

  FindDeviceParam._(this.address, this.name) : assert(!(address == null && name == null));

  factory FindDeviceParam.byAddress(String address) => FindDeviceParam._(address, null);
  factory FindDeviceParam.byName(String name) => FindDeviceParam._(null, name);

  @override
  Map<String, dynamic> get fields => {"address": address, "name": name};

  @override
  List<Object?> get props => [address, name];
}
