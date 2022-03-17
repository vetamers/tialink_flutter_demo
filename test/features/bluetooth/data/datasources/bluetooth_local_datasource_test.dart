import 'package:faker/faker.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:tialink/core/exceptions/bluetooth_exceptions.dart';
import 'package:tialink/features/bluetooth/data/datasources/bluetooth_local_datasource.dart';

import '../../../../utils/faker.dart';
import 'bluetooth_local_datasource_test.mocks.dart';

@GenerateMocks([FlutterBluetoothSerial])
void main() {
  var serial = MockFlutterBluetoothSerial();
  var dataSource = BluetoothDataSourceImpl(serial);

  group("find", () {
    test("Should return BluetoothDiscoveryResult when searching by name", () async {
      when(serial.isDiscovering).thenAnswer((_) async => false);
      when(serial.startDiscovery()).thenAnswer((_) => fakeDiscovery(name: "test"));

      expect(await dataSource.find(name: "test"), isA<BluetoothDiscoveryResult>());

      verifyInOrder([serial.isDiscovering, serial.startDiscovery()]);
      verifyNever(serial.cancelDiscovery());
      verifyNoMoreInteractions(serial);
    });

    test("Should return BluetoothDiscoveryResult when searching by address", () async {
      var testAddress = Faker().internet.macAddress();

      when(serial.isDiscovering).thenAnswer((_) async => false);
      when(serial.startDiscovery()).thenAnswer((_) => fakeDiscovery(address: testAddress));

      expect(await dataSource.find(address: testAddress), isA<BluetoothDiscoveryResult>());

      verifyInOrder([serial.isDiscovering, serial.startDiscovery()]);
      verifyNever(serial.cancelDiscovery());
      verifyNoMoreInteractions(serial);
    });

    test("Should throw AssertionError when address and name is null", () async {
      when(serial.isDiscovering).thenAnswer((_) async => false);
      when(serial.startDiscovery()).thenAnswer((_) => fakeDiscovery());

      expect(() async => await dataSource.find(), throwsA(isA<AssertionError>()));

      verifyNever(serial.isDiscoverable);
      verifyNever(serial.startDiscovery());
      verifyNoMoreInteractions(serial);
    });

    test("Should throw BluetoothTargetNotFound when target not found", () async {
      when(serial.isDiscovering).thenAnswer((_) async => false);
      when(serial.startDiscovery()).thenAnswer((_) => fakeDiscovery(name: "abc"));

      expect(() async => await dataSource.find(name: "test"), throwsA(isA<BluetoothTargetNotFound>()));

      verify(serial.isDiscovering);
    });
  });
}
