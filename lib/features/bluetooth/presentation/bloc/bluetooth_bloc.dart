import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:tialink/features/bluetooth/domain/usecases/bluetooth_find_usecase.dart';

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final FindDeviceByName findDeviceByName;
  final FindDeviceByAddress findDeviceByAddress;

  BluetoothBloc(this.findDeviceByName, this.findDeviceByAddress) : super(BluetoothState.initial()) {
    on<BluetoothFindDeviceEvent>(_findDevice);
  }

  void _findDevice(BluetoothFindDeviceEvent event, Emitter<BluetoothState> emit) async {
    emit(BluetoothState.discovering());
    if (event.param.address != null) {
      var response = await findDeviceByAddress(event.param);
      response.fold((l) => emit(BluetoothState.deviceFound(l)), (r) => emit(BluetoothState.deviceNotFound()));
    } else {
      var response = await findDeviceByName(event.param);
      response.fold((l) => emit(BluetoothState.deviceFound(l)), (r) => emit(BluetoothState.deviceNotFound()));
    }
  }
}
