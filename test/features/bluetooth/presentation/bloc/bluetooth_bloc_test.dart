import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bluetooth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/features/bluetooth/domain/usecases/bluetooth_execute_usecase.dart';
import 'package:tialink/features/bluetooth/domain/usecases/bluetooth_find_usecase.dart';
import 'package:tialink/features/bluetooth/presentation/bloc/bluetooth_bloc.dart';

import '../../../../utils/faker.dart';
import 'bluetooth_bloc_test.mocks.dart';

class FlutterBluetoothMock extends Mock implements bluetooth.FlutterBluetoothSerial {
  @override
  Stream<bluetooth.BluetoothState> onStateChanged() async* {
    yield bluetooth.BluetoothState.STATE_ON;
  }

  @override
  Future<bool?> get isEnabled => Future.value(true);
}

@GenerateMocks([
  FindDeviceByAddress,
  FindDeviceByName,
  ExecuteCommand
])
void main() {
  final MockFindDeviceByAddress findDeviceByAddress = MockFindDeviceByAddress();
  final MockFindDeviceByName findDeviceByName = MockFindDeviceByName();
  final MockExecuteCommand executeCommand = MockExecuteCommand();

  var bluetoothBloc = BluetoothBloc(FlutterBluetoothMock(),findDeviceByName, findDeviceByAddress,executeCommand);
  var testDiscoveryResult =bluetooth.BluetoothDiscoveryResult(device: fakeBluetoothDevice());

  test("Initial test", () {
    expect(bluetoothBloc.isClosed, false);
    expect(bluetoothBloc.state, BluetoothState.enable());
  });

  group("Normal flow test", () {


    setUp(() {
      bluetoothBloc = BluetoothBloc(FlutterBluetoothMock(),findDeviceByName, findDeviceByAddress,executeCommand);
      when(findDeviceByName.call(any)).thenAnswer((_) async => Left(testDiscoveryResult));
    });

    blocTest<BluetoothBloc, BluetoothState>(
        "Should emit [discovering,deviceFound] when BluetoothFindDeviceEvent added",
        build: () => bluetoothBloc,
        act: (b) => b.add(BluetoothFindDeviceEvent(FindDeviceParam.byName("name"))),
        expect: () => [
          BluetoothState.discovering(),
          BluetoothState.deviceFound(testDiscoveryResult)
        ],
        verify: (_) {
          verify(findDeviceByName.call(any));
        });
  });
}