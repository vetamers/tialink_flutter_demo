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

class BluetoothRequestEnableEvent extends BluetoothEvent {}

class BluetoothConnectEvent extends BluetoothEvent {
  final plugin.BluetoothDiscoveryResult result;

  const BluetoothConnectEvent(this.result);
}

class BluetoothExecuteRemoteEvent extends BluetoothEvent {
  final Home home;
  final Door door;
  final RemoteButton button;

  const BluetoothExecuteRemoteEvent(this.home, this.door, this.button);
}
