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
  connectionFailed,
  disconnected
}

class BluetoothState extends Equatable {
  final BluetoothStatus value;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [value, metadata];

  const BluetoothState._(this.value, [this.metadata = const {}]);

  factory BluetoothState.initial() =>
      const BluetoothState._(BluetoothStatus.initial);
  factory BluetoothState.enable() => const BluetoothState._(BluetoothStatus.enabled);
  factory BluetoothState.disable() =>
      const BluetoothState._(BluetoothStatus.disable);
  factory BluetoothState.discovering() =>
      const BluetoothState._(BluetoothStatus.discovering);
  factory BluetoothState.deviceFound(plugin.BluetoothDiscoveryResult result) =>
      BluetoothState._(BluetoothStatus.deviceFound, {"result": result});
  factory BluetoothState.deviceNotFound() =>
      const BluetoothState._(BluetoothStatus.deviceNotFound);
  factory BluetoothState.connecting(plugin.BluetoothDiscoveryResult result) =>
      BluetoothState._(BluetoothStatus.connecting, {"result": result});
  factory BluetoothState.connected() =>
      const BluetoothState._(BluetoothStatus.connected);
  factory BluetoothState.connectionFailed(plugin.BluetoothDevice device) =>
      BluetoothState._(BluetoothStatus.connectionFailed, {"device": device});

  factory BluetoothState.disconnected() =>
      const BluetoothState._(BluetoothStatus.disconnected);
}
