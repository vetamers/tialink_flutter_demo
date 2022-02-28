part of 'bluetooth_bloc.dart';

enum BluetoothStatus {
  initial,
  enabled,
  disabled,
  discovering,
  deviceFound,
  deviceNotFound,
  connecting,
  connected,
  connectionFailed,
}


class BluetoothState extends Equatable{

  final BluetoothStatus value;

  const BluetoothState(this.value);

  @override
  List<Object?> get props => [value];

}

class BluetoothStateDeviceFound extends BluetoothState{
  final BluetoothDiscoveryResult result;
  const BluetoothStateDeviceFound(this.result) : super(BluetoothStatus.deviceFound);
}