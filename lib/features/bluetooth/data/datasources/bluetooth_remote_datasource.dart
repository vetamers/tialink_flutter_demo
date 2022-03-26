import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';

abstract class BluetoothRemoteDataSource {
  Future<void> sendBytes(Uint8List bytes);
  Future<Uint8List> readBytes(int length);
}

class BluetoothRemoteDataSourceImpl implements BluetoothRemoteDataSource {
  final BluetoothConnection _connection;
  Stream<Uint8List>? inputStream;

  BluetoothRemoteDataSourceImpl(this._connection) {
    inputStream = _connection.input!.asBroadcastStream();
  }

  @override
  Future<Uint8List> readBytes(int length) async {
    String s = "";
    await for (Uint8List uInt in inputStream!) {
      s += ascii.decode(uInt);

      if (s.length == length) {
        log("Message received: $s");
        return Uint8List.fromList(ascii.encode(s));
      }
    }

    throw BluetoothReadBytesException(length, s.length);
  }

  @override
  Future<void> sendBytes(Uint8List bytes) {
    log("Message send: " + ascii.decode(bytes));
    _connection.output.add(bytes);
    return _connection.output.allSent;
  }
}
