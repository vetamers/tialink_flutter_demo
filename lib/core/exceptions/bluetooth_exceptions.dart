import 'package:flutter/cupertino.dart';

class BluetoothException extends ErrorDescription {
  final String code;
  final String message;

  BluetoothException(this.code, this.message) : super("$code: $message");

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothException &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class BluetoothConnectException extends BluetoothException {
  BluetoothConnectException(String address)
      : super("CONNECT_ERROR", "Can't connect to $address");
}

class BluetoothTargetNotFound extends BluetoothException {
  BluetoothTargetNotFound(String? address, String? name)
      : super("TARGET_NOT_FOUND", "\naddress: $address\nname: $name");
}

class BluetoothReadBytesException extends BluetoothException {
  BluetoothReadBytesException(int expectedLength, int actualLength)
      : super("READ_FAILED",
            "Error while read bytes.\nExpected: $expectedLength\nActual: $actualLength");
}

class BluetoothUnExpectedMessage extends BluetoothException {
  BluetoothUnExpectedMessage(String expected, String actual)
      : super("UNEXPECTED_MESSAGE",
            "Unexpected message.\nExpected: $expected\nActual: $actual");
}
