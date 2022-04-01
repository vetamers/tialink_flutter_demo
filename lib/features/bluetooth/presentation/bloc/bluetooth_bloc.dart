import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as plugin;
import 'package:get_it/get_it.dart';
import 'package:tialink/features/bluetooth/data/datasources/bluetooth_remote_datasource.dart';
import 'package:tialink/features/bluetooth/domain/entities/bluetooth_entities.dart';
import 'package:tialink/features/bluetooth/domain/repositories/bluetooth_repository.dart';
import 'package:tialink/features/bluetooth/domain/usecases/bluetooth_find_usecase.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final plugin.FlutterBluetoothSerial _serial;
  StreamSubscription<plugin.BluetoothState>? _bluetoothState;

  final FindDeviceByName findDeviceByName;
  final FindDeviceByAddress findDeviceByAddress;

  plugin.BluetoothDevice? device;

  BluetoothBloc(this._serial, this.findDeviceByName, this.findDeviceByAddress)
      : super(BluetoothState.initial()) {
    _checkIsBluetoothEnable();

    _bluetoothState = _serial.onStateChanged().listen((event) {
      if (event.isEnabled) {
        emit(BluetoothState.enable());
      } else {
        emit(BluetoothState.disable());
      }
    });

    stream.listen((event) {
      if (event.value == BluetoothStatus.connected) {
        GetIt.I<BluetoothRepository>().isRemoteSourceConnected.listen((event) {
          if (!event) {
            emit(BluetoothState.disconnected());
          }
        });
      }
    });

    on<BluetoothRequestEnableEvent>(_requestEnableBluetooth);
    on<BluetoothFindDeviceEvent>(_findDevice);
    on<BluetoothConnectEvent>(_connect);

    on<BluetoothExecuteRemoteEvent>(_executeRemote);
  }

  void _findDevice(
      BluetoothFindDeviceEvent event, Emitter<BluetoothState> emit) async {
    emit(BluetoothState.discovering());
    if (event.param.address != null) {
      var response = await findDeviceByAddress(event.param);
      response.fold((l) => emit(BluetoothState.deviceFound(l)),
          (r) => emit(BluetoothState.deviceNotFound()));
    } else {
      var response = await findDeviceByName(event.param);
      response.fold((l) => emit(BluetoothState.deviceFound(l)),
          (r) => emit(BluetoothState.deviceNotFound()));
    }
  }

  void _requestEnableBluetooth(
      BluetoothRequestEnableEvent event, Emitter<BluetoothState> emit) async {
    if ((await _serial.requestEnable()) == true) {
      emit(BluetoothState.enable());
    } else {
      emit(BluetoothState.disable());
    }
  }

  Future<bool> _checkIsBluetoothEnable() async {
    if ((await _serial.isEnabled) != true) {
      emit(BluetoothState.disable());
      return false;
    } else {
      emit(BluetoothState.enable());
      return true;
    }
  }

  @override
  Future<void> close() {
    _bluetoothState?.cancel();
    return super.close();
  }

  void _connect(BluetoothConnectEvent event, Emitter<BluetoothState> emit) async {
    emit(BluetoothState.connecting(event.result));
    try {
      var result =
          await plugin.BluetoothConnection.toAddress(event.result.device.address);
      if (result.isConnected) {
        device = event.result.device;
        GetIt.I<BluetoothRepository>().remoteSource =
            GetIt.I<BluetoothRemoteDataSource>(param1: result);

        emit(BluetoothState.connected());
      } else {
        emit(BluetoothState.connectionFailed(event.result.device));
      }
    } catch (e) {
      emit(BluetoothState.connectionFailed(event.result.device));
    }
  }

  void _executeRemote(
      BluetoothExecuteRemoteEvent event, Emitter<BluetoothState> emit) {
    //TODO: Complete this section
  }
}
