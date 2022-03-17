import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';

abstract class BluetoothRemoteDataSource {
  void sendBytes(Uint8List bytes);
  Future<Uint8List> readBytes(int length);
}

class BluetoothRemoteDataSourceImpl implements BluetoothRemoteDataSource{
  final BluetoothConnection _connection;

  BluetoothRemoteDataSourceImpl(this._connection);

  @override
  Future<Uint8List> readBytes(int length) async {
   String s = "";
   await for (Uint8List uInt in _connection.input!){
     s += ascii.decode(uInt);

     if (s.length == length){
       return uInt;
     }
   }

   throw BluetoothReadBytesException(length,s.length);
  }

  @override
  void sendBytes(Uint8List bytes) {
    _connection.output.add(bytes);
  }

}