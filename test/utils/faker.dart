import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

@visibleForTesting
BluetoothDevice fakeBluetoothDevice() {
  var address = Faker().internet.macAddress();
  var name = Faker().company.name();

  return BluetoothDevice(address: address, name: name);
}

@visibleForTesting
Stream<BluetoothDiscoveryResult> fakeDiscovery({String? address, String? name}) {
  assert(!(address == null && name == null));

  address ??= Faker().internet.macAddress();

  var resultList = List.generate(
    5,
    (index) => BluetoothDiscoveryResult(device: fakeBluetoothDevice()),
  );

  var expectedDevice = BluetoothDevice(address: address, name: name);
  resultList.insert(Faker().randomGenerator.integer(5), BluetoothDiscoveryResult(device: expectedDevice));

  return Stream.fromIterable(resultList);
}
