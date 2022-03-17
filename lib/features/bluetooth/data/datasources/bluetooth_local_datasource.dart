import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';

abstract class BluetoothLocalDataSource {
  Future<BluetoothDiscoveryResult> find({String? address, String? name});
  Future<BluetoothConnection> connect(String address);
  Future<void> dispose();
}

class BluetoothDataSourceImpl implements BluetoothLocalDataSource {
  final FlutterBluetoothSerial _serial;

  BluetoothDataSourceImpl(this._serial);

  @override
  Future<BluetoothConnection> connect(String address) async {
    await _cancelDiscovery();

    var result = await BluetoothConnection.toAddress(address);
    if (result.isConnected) {
      return result;
    } else {
      throw BluetoothConnectException(address);
    }
  }

  @override
  Future<BluetoothDiscoveryResult> find({String? address, String? name}) async {
    assert(!(address == null && name == null));
    await _cancelDiscovery();
    var result = await _serial
        .startDiscovery()
        .cast<BluetoothDiscoveryResult?>()
        .firstWhere(
            (element) =>
                element!.device.address == address || element.device.name == name,
            orElse: () => null);

    if (result != null) {
      return result;
    } else {
      throw BluetoothTargetNotFound(address, name);
    }
  }

  Future<void> _cancelDiscovery() async {
    if (await _serial.isDiscovering == true) {
      await _serial.cancelDiscovery();
    }
  }

  @override
  Future<void> dispose() async {
    await _serial.cancelDiscovery();
  }
}
