import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';
import 'dart:typed_data';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  static String requestCommand(int doorNumber, int config) => "r${doorNumber}m$config";
  static String doneMessage(RemoteButton button) => "d${button.name}";

  final FlutterBluetoothSerial _serial;
  BluetoothConnection? _connection;
  BluetoothDevice? _device;
  Stream<Uint8List>? _inputStream;

  bool isDeviceConnected() => _connection?.isConnected == true;

  BluetoothBloc(this._serial) : super(const BluetoothState(BluetoothStatus.initial)) {
    on<BluetoothDiscoveryEvent>(_discovery);
    on<BluetoothConnectEvent>(_connect);
    on<BluetoothNewRemoteEvent>(_newRemote);
  }

  Future<void> _discovery(
      BluetoothDiscoveryEvent event, Emitter<BluetoothState> emit) async {
    emit(const BluetoothState(BluetoothStatus.discovering));

    var discovery = await _serial
        .startDiscovery()
        .cast<dynamic>()
        .firstWhere((element) => _isTiaLinkDevice(element.device), orElse: () => false);

    emit(discovery is bool
        ? const BluetoothState(BluetoothStatus.deviceNotFound)
        : BluetoothStateDeviceFound(discovery));
  }

  bool _isTiaLinkDevice(BluetoothDevice device) {
    return device.name == "meta";
  }

  Future<void> _connect(BluetoothConnectEvent event, Emitter<BluetoothState> emit) async {
    if (_connection != null) {
      _connection!.close();
    }

    var connection = await BluetoothConnection.toAddress(event.device.address);

    if (connection.isConnected) {
      _device = event.device;
      _connection = connection;
      _inputStream = connection.input!;

      emit(const BluetoothState(BluetoothStatus.connected));
    } else {
      emit(const BluetoothState(BluetoothStatus.connectionFailed));
    }
  }

  FutureOr<void> _send(BluetoothSendData event, Emitter<BluetoothState> emit) async {
    if (isDeviceConnected()) {
      _connection!.output.add(Uint8List.fromList(event.data.codeUnits));
    }
  }

  @override
  Future<void> close() {
    _serial.cancelDiscovery();
    _connection?.close();

    return super.close();
  }

  FutureOr<void> _newRemote(
      BluetoothNewRemoteEvent event, Emitter<BluetoothState> emit) async {
    if (isDeviceConnected()) {
      // Send request command
      _connection!.output.add(Uint8List.fromList(
          requestCommand(event.doorNumber, event.buttonMode).codeUnits));
      emit(BluetoothState(
          BluetoothStatus.waitingForData, {"step": 1, "total_step": event.buttonMode}));

      var string = "";
      var step = 1;
      var secret = generateRandomInt();
      await for (var e in _inputStream!) {
        string += String.fromCharCodes(e);

        log(string + "$e");

        if (string.length >= 2) {
          if (string == doneMessage(RemoteButton.values[step - 1])) {
            if (step == event.buttonMode) {
              log(secret);
              _connection!.output.add(Uint8List.fromList(secret.codeUnits));
              emit(BluetoothState(BluetoothStatus.operationDone,{"address":_device!.address,"secret":secret,"button_mode":event.buttonMode}));
              break;
            } else {
              string = "";
              step++;
              emit(const BluetoothDataReceived());
              await Future.delayed(Duration(seconds: 1));
              emit(BluetoothState(BluetoothStatus.waitingForData,
                  {"step": step, "total_step": event.buttonMode}));
            }
          } else {
            log("Done message is uncorrected. Must be `${doneMessage(RemoteButton.values[step - 1])}`");
          }
        }
      }
    } else {
      emit(const BluetoothState(BluetoothStatus.disconnected));
    }
  }

  String generateRandomInt([int length = 8]) {
    var chars = '0123456789';
    var random = math.Random();

    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }
}
