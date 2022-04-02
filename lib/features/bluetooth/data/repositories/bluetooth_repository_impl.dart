import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/core/utils.dart';
import 'package:tialink/features/bluetooth/data/datasources/bluetooth_local_datasource.dart';
import 'package:tialink/features/bluetooth/data/datasources/bluetooth_remote_datasource.dart';
import 'package:tialink/features/bluetooth/data/models/bluetooth_models.dart';
import 'package:tialink/features/bluetooth/domain/entities/bluetooth_entities.dart';
import 'package:tialink/features/bluetooth/domain/repositories/bluetooth_repository.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothLocalDataSource _localDataSource;
  BluetoothRemoteDataSource? _remoteDataSource;

  BluetoothRepositoryImpl(this._localDataSource, [this._remoteDataSource]);

  @override
  set remoteSource(BluetoothRemoteDataSource remoteDataSource) {
    _remoteDataSource = remoteDataSource;
    log("RemoteDataSource attached");
    _remoteDataSource!.isConnected.listen((event) {
      if (!event) {
        _remoteDataSource = null;
        log("RemoteDataSource detached");
      }
    });
  }

  @override
  Future<Either<BluetoothConnection, BluetoothConnectException>> connect(
      BluetoothDevice device) async {
    try {
      var response = await _localDataSource.connect(device.address);
      return Left(response);
    } on BluetoothConnectException catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<BluetoothDiscoveryResult, BluetoothTargetNotFound>>
      findTiaLinkDeviceWithAddress(String address) async {
    try {
      var response = await _localDataSource.find(address: address);
      return Left(response);
    } on BluetoothTargetNotFound catch (e) {
      return Right(e);
    }
  }

  @override
  Future<Either<BluetoothDiscoveryResult, BluetoothTargetNotFound>>
      findTiaLinkDeviceWithName(String name) async {
    try {
      var response = await _localDataSource.find(name: name);
      return Left(response);
    } on BluetoothTargetNotFound catch (e) {
      return Right(e);
    }
  }

  @override
  Stream<bool> get isRemoteSourceConnected => _remoteDataSource == null
      ? Stream.value(false)
      : _remoteDataSource!.isConnected;

  @override
  Stream<RemoteSetupState> setupNewRemote(int buttonMode, int remoteNumber) async* {
    var secret = randomInt(8);
    await _remoteDataSource!.sendBytes(
        TransferProtocol.newRemoteSetupMessage(buttonMode, remoteNumber).binary);

    for (int i = 1; i <= buttonMode; i++) {
      var expectedMessage =
          TransferProtocol.successfulMessage(RemoteButton.values[i - 1]).message;
      yield RemoteSetupState(
          buttonMode, i, secret.toString(), RemoteSetupStatus.waitingForAction);
      var bytes = await _remoteDataSource!.readBytes(expectedMessage.length);
      var message = TransferProtocol.binaryToString(bytes);

      if (message == expectedMessage) {
        yield RemoteSetupState(
            buttonMode, i, secret.toString(), RemoteSetupStatus.signalReceived);
        await Future.delayed(const Duration(seconds: 1));
      } else {
        throw BluetoothUnExpectedMessage(expectedMessage, message);
      }
    }

    await _remoteDataSource!.sendBytes(TransferProtocol.uniqueKey(secret).binary);
    yield RemoteSetupState(
        buttonMode, buttonMode, secret.toString(), RemoteSetupStatus.operationDone);
  }

  @override
  Future<Either<void, BluetoothSendBytesException>> sendCommand(TransferProtocol transferProtocol) async {
    assert(_remoteDataSource != null);

    try {
      return left(_remoteDataSource!.sendBytes(transferProtocol.binary));
    }catch (e) {
      return right(BluetoothSendBytesException(transferProtocol));
    }
  }
}
