part of 'bluetooth_bloc.dart';

enum BluetoothStatus {
  initial,
  enabled,
  disable,
  discovering,
  deviceFound,
  deviceNotFound,
  connecting,
  connected,
}

class BluetoothState extends Equatable {
  final BluetoothStatus value;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [value, metadata];

  const BluetoothState._(this.value, [this.metadata = const {}]);

  factory BluetoothState.initial() => const BluetoothState._(BluetoothStatus.initial);
  factory BluetoothState.enable() => const BluetoothState._(BluetoothStatus.enabled);
  factory BluetoothState.disable() => const BluetoothState._(BluetoothStatus.disable);
  factory BluetoothState.discovering() => const BluetoothState._(BluetoothStatus.discovering);
  factory BluetoothState.deviceFound(BluetoothDiscoveryResult result) =>
      BluetoothState._(BluetoothStatus.deviceFound, {"result": result});
  factory BluetoothState.deviceNotFound() => const BluetoothState._(BluetoothStatus.deviceNotFound);
  factory BluetoothState.connecting() => const BluetoothState._(BluetoothStatus.connecting);
  factory BluetoothState.connected(BluetoothConnection connection) =>
      BluetoothState._(BluetoothStatus.connected, {"connection": connection});

  //TODO: Add more state factory :/
}
