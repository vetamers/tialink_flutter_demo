import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/features/bluetooth/domain/entities/bluetooth_entities.dart';

abstract class BluetoothRepository {
  Future<Either<BluetoothDiscoveryResult,BluetoothTargetNotFound>> findTiaLinkDeviceWithName(String name);
  Future<Either<BluetoothDiscoveryResult,BluetoothTargetNotFound>> findTiaLinkDeviceWithAddress(String address);

  Future<Either<BluetoothConnection,BluetoothConnectException>> connect(BluetoothDevice device);

  Stream<RemoteSetupStatus> setupNewRemote(int buttonMode,int remoteNumber);
}