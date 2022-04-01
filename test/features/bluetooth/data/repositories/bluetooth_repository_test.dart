import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/features/bluetooth/data/datasources/bluetooth_local_datasource.dart';
import 'package:tialink/features/bluetooth/data/datasources/bluetooth_remote_datasource.dart';
import 'package:tialink/features/bluetooth/data/repositories/bluetooth_repository_impl.dart';
import 'package:tialink/features/bluetooth/domain/entities/bluetooth_entities.dart';

import '../../../../utils/faker.dart';
import 'bluetooth_repository_test.mocks.dart';

class MockBluetoothConnection extends Mock implements BluetoothConnection {}

@GenerateMocks([BluetoothLocalDataSource, BluetoothRemoteDataSource])
void main() {
  var localSource = MockBluetoothLocalDataSource();
  var remoteSource = MockBluetoothRemoteDataSource();
  var repository = BluetoothRepositoryImpl(localSource);

  when(remoteSource.isConnected).thenAnswer((_) => Stream.value(true));

  repository.remoteSource = remoteSource;

  group("connect", () {
    test("Should return BluetoothConnection", () async {
      when(localSource.connect(any)).thenAnswer((_) async => MockBluetoothConnection());

      expect(await repository.connect(fakeBluetoothDevice()), isA<Left<BluetoothConnection, dynamic>>());

      verify(localSource.connect(any));
      verifyNoMoreInteractions(localSource);
    });

    test("Should throw BluetoothConnectException", () async {
      when(localSource.connect(any)).thenThrow(BluetoothConnectException(""));

      expect(
          await repository.connect(fakeBluetoothDevice()), isA<Right<dynamic, BluetoothConnectException>>());

      verify(localSource.connect(any));
      verifyNoMoreInteractions(localSource);
    });
  });

  group("find", () {
    test("Should return BluetoothDiscovery result", () async {
      when(localSource.find(address: "address", name: null))
          .thenAnswer((_) async => BluetoothDiscoveryResult(device: fakeBluetoothDevice()));
      when(localSource.find(address: null, name: "name"))
          .thenAnswer((_) async => BluetoothDiscoveryResult(device: fakeBluetoothDevice()));

      expect(await repository.findTiaLinkDeviceWithAddress("address"),
          isA<Left<BluetoothDiscoveryResult, dynamic>>());
      expect(
          await repository.findTiaLinkDeviceWithName("name"), isA<Left<BluetoothDiscoveryResult, dynamic>>());

      verify(localSource.find(address: "address", name: null));
      verify(localSource.find(address: null, name: "name"));
      verifyNoMoreInteractions(localSource);
    });

    test("Should throw BluetoothTargetNotFound", () async {
      when(localSource.find(address: "address", name: null))
          .thenThrow(BluetoothTargetNotFound("address", "name"));
      when(localSource.find(address: null, name: "name"))
          .thenThrow(BluetoothTargetNotFound("address", "name"));
      expect(await repository.findTiaLinkDeviceWithAddress("address"),
          isA<Right<dynamic, BluetoothTargetNotFound>>());
      expect(
          await repository.findTiaLinkDeviceWithName("name"), isA<Right<dynamic, BluetoothTargetNotFound>>());

      verify(localSource.find(address: "address", name: null));
      verify(localSource.find(address: null, name: "name"));
      verifyNoMoreInteractions(localSource);
    });
  });

  group("setupNewRemote", () {
    test("Stream should work normally", () async {
      when(remoteSource.sendBytes(ascii.encode("r1m1"))).thenAnswer((_) async => (){});
      when(remoteSource.readBytes(any)).thenAnswer((_) async => ascii.encode("da"));

      expect(
          repository.setupNewRemote(1, 1),
          emitsInOrder([
            const RemoteSetupState(1,1,"",RemoteSetupStatus.waitingForAction),
            const RemoteSetupState(1,1,"",RemoteSetupStatus.signalReceived),
            const RemoteSetupState(1,1,"",RemoteSetupStatus.operationDone),
            emitsDone
          ]));
    });
  });
}
