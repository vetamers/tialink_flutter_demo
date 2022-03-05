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
  disconnected,
  dataReceived,
  waitingForData,
  operationDone
}

enum RemoteButton { a, b, c, d }

class BluetoothState extends Equatable {
  final BluetoothStatus value;
  final Map<String, dynamic> metadata;

  const BluetoothState(this.value, [this.metadata = const {}]);

  @override
  List<Object?> get props => [value,metadata];
}

class BluetoothStateDeviceFound extends BluetoothState {
  final BluetoothDiscoveryResult result;
  const BluetoothStateDeviceFound(this.result) : super(BluetoothStatus.deviceFound);
}

class BluetoothDataReceived extends BluetoothState {
  const BluetoothDataReceived() : super(BluetoothStatus.dataReceived);

  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch];
}
