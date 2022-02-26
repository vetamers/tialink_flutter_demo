part of 'bluetooth_bloc.dart';

@immutable
abstract class BluetoothEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class BluetoothDiscoveryEvent extends BluetoothEvent{

}

class BluetoothConnectEvent extends BluetoothEvent{
  final BluetoothDevice device;

  BluetoothConnectEvent(this.device);
}

class BluetoothSendData extends BluetoothEvent{
  final String data;

  BluetoothSendData(this.data);
}