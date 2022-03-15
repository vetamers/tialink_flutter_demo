import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class StorageService {
  Future<void> init();
  Future<Box<dynamic>> secureBox(String name);
  Future<void> dispose();
}

class StorageServiceImpl implements StorageService{
  final FlutterSecureStorage secureStorage;
  
  StorageServiceImpl(this.secureStorage);

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    log("Storage initialized");
  }

  @override
  Future<Box<dynamic>> secureBox(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box(name);

    var key = await secureStorage.read(key: name);
    if(key == null){
      var secureKey = Hive.generateSecureKey();
      await secureStorage.write(key: name, value: base64Encode(secureKey));
      return Hive.openBox(name,encryptionCipher: HiveAesCipher(secureKey));
    }else{
      return Hive.openBox(name,encryptionCipher: HiveAesCipher(base64Decode(key)));
    }
  }

  @override
  Future<void> dispose() {
    log("Storage disposed");
    return Hive.close();
  }
}