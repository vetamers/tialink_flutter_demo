import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/core/usecases/usecase.dart';
import 'package:tialink/features/bluetooth/domain/repositories/bluetooth_repository.dart';

class ConnectToDevice extends UseCase<BluetoothConnection, BluetoothConnectException, ConnectToDeviceParam> {
  final BluetoothRepository _repository;

  ConnectToDevice(this._repository);

  @override
  Future<Either<BluetoothConnection, BluetoothConnectException>> call(ConnectToDeviceParam param) {
    return _repository.connect(param.device);
  }
}

class ConnectToDeviceParam extends UseCaseParam {
  final BluetoothDevice device;

  ConnectToDeviceParam(this.device);

  @override
  Map<String, dynamic> get fields => {"device": device};

  @override
  List<Object?> get props => [device];
}
