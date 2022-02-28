import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';
import 'dart:typed_data';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {

  static requestCommand(int doorNumber,int config) => "r${doorNumber}m$config";

  final FlutterBluetoothSerial _serial;
  BluetoothConnection? _connection;

  bool isDeviceConnected() => _connection?.isConnected == true;


  BluetoothBloc(this._serial) : super(const BluetoothState(BluetoothStatus.initial)) {
    on<BluetoothDiscoveryEvent>(_discovery);
    on<BluetoothConnectEvent>(_connect);
    on<BluetoothSendData>(_send);

    stream.listen((event) {
      if (event.value == BluetoothStatus.deviceFound){
        _serial.cancelDiscovery();
      }
    });
  }

  Future<void> _discovery(BluetoothDiscoveryEvent event, Emitter<BluetoothState> emit) async {
    emit(const BluetoothState(BluetoothStatus.discovering));

    var discovery = await _serial
        .startDiscovery()
        .cast<dynamic>()
        .firstWhere((element) => _isTiaLinkDevice(element.device),orElse: () => false);

    emit(discovery is bool ? const BluetoothState(BluetoothStatus.deviceNotFound) : BluetoothStateDeviceFound(discovery));

  }

  bool _isTiaLinkDevice(BluetoothDevice device){
    return device.name == "meta";
  }

  Future<void> _connect(BluetoothConnectEvent event, Emitter<BluetoothState> emit) async {
    if (_connection != null){
      _connection!.close();
    }

    var connection = await BluetoothConnection.toAddress(event.device.address);

    if (connection.isConnected){
      _connection = connection;
      emit(const BluetoothState(BluetoothStatus.connected));
    }else{
      emit(const BluetoothState(BluetoothStatus.connectionFailed));
    }
  }

  FutureOr<void> _send(BluetoothSendData event, Emitter<BluetoothState> emit) async {
    if (isDeviceConnected()){
        _connection!.output.add(Uint8List.fromList(event.data.codeUnits));
    }
  }


  @override
  Future<void> close() {
    _serial.cancelDiscovery();
    _connection?.close();
    return super.close();
  }
}