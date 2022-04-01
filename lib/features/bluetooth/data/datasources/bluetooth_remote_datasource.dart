import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';

abstract class BluetoothRemoteDataSource {
  Stream<bool> get isConnected;
  Future<void> sendBytes(Uint8List bytes);
  Future<Uint8List> readBytes(int length);
}

class BluetoothRemoteDataSourceImpl implements BluetoothRemoteDataSource {
  final BluetoothConnection _connection;
  Stream<Uint8List>? _inputStream;

  BluetoothRemoteDataSourceImpl(this._connection) {
    _inputStream = _connection.input!.asBroadcastStream();
  }

  @override
  Stream<bool> get isConnected => _isConnected();

  @override
  Future<Uint8List> readBytes(int length) async {
    String s = "";
    await for (Uint8List uInt in _inputStream!) {
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

  Stream<bool> _isConnected() async* {
    if (_connection.isConnected) {
      yield true;
      try {
        await _inputStream!.last;
        yield false;
      } catch (e) {
        yield false;
      }
    } else {
      yield false;
    }
  }
}
