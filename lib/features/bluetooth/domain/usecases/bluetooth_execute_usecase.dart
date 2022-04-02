import 'package:dartz/dartz.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/core/usecases/usecase.dart';
import 'package:tialink/features/bluetooth/data/models/bluetooth_models.dart';
import 'package:tialink/features/bluetooth/domain/repositories/bluetooth_repository.dart';

class ExecuteCommandParam extends UseCaseParam {
  final TransferProtocol transferProtocol;

  ExecuteCommandParam(this.transferProtocol);

  @override
  Map<String, dynamic> get fields => throw UnimplementedError();

  @override
  List<Object?> get props => [transferProtocol];
}

class ExecuteCommand extends UseCase<void,BluetoothSendBytesException,ExecuteCommandParam> {
  final BluetoothRepository _repository;

  ExecuteCommand(this._repository);

  @override
  Future<Either<void, BluetoothSendBytesException>> call(ExecuteCommandParam param) {
    return _repository.sendCommand(param.transferProtocol);
  }

}