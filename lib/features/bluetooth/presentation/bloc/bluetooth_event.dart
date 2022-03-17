part of 'bluetooth_bloc.dart';

abstract class BluetoothEvent extends Equatable {
  const BluetoothEvent();

  @override
  List<Object> get props => [];
}

class BluetoothFindDeviceEvent extends BluetoothEvent {
  final FindDeviceParam param;

  const BluetoothFindDeviceEvent(this.param);
}
