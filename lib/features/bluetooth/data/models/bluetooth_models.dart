import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../domain/entities/bluetooth_entities.dart';

class TransferProtocol extends Equatable {
  final String message;
  late Uint8List binary;

  @override
  List<Object?> get props => [message];

  TransferProtocol._(this.message) {
    binary = stringToBinary(message);
  }

  static String binaryToString(Uint8List uInt8list) => ascii.decode(uInt8list);
  static Uint8List stringToBinary(String s) => ascii.encode(s);

  factory TransferProtocol.newRemoteSetupMessage(int buttonMode, int remoteNumber) {
    var message = "r${remoteNumber}m$buttonMode"; //Ex. 'r1m2'
    return TransferProtocol._(message);
  }

  factory TransferProtocol.successfulMessage(RemoteButton button) {
    var message = "d${button.name}"; //Ex. 'da'
    return TransferProtocol._(message);
  }

  factory TransferProtocol.uniqueKey(String key) {
    var message = key.toString(); //Ex. '12345678'
    assert(message.length == 8);
    return TransferProtocol._(message.toString());
  }

  factory TransferProtocol.executeButton(RemoteButton button,int doorNumber,String secret) {
    assert(doorNumber > 0 && doorNumber <= 4);
    assert(secret.length == 8);

    var message = "r${doorNumber}b${button.name.toUpperCase()}_$secret"; //Ex. r1bA_12345678
    return TransferProtocol._(message);
  }
}
