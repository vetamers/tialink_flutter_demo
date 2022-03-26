import 'dart:convert';
import 'dart:typed_data';

import '../../domain/entities/bluetooth_entities.dart';

class TransferProtocol {
  final String message;
  late Uint8List binary;

  TransferProtocol._(this.message) {
    binary = stringToBinary(message);
  }

  static String binaryToString(Uint8List uInt8list) => ascii.decode(uInt8list);
  static Uint8List stringToBinary(String s) => ascii.encode(s);

  factory TransferProtocol.newRemoteSetupMessage(int buttonMode, int remoteNumber) {
    var message = "r${remoteNumber}m$buttonMode";
    return TransferProtocol._(message);
  }

  factory TransferProtocol.successfulMessage(RemoteButton button) {
    var message = "d${button.name}";
    return TransferProtocol._(message);
  }

  factory TransferProtocol.uniqueKey(int key) {
    var message = key.toString();
    assert(message.length == 8);
    return TransferProtocol._(message.toString());
  }
}
