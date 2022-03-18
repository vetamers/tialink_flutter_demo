import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tialink/core/services/storage_service.dart';

Future<void> initInjector() async {
  final GetIt sl = GetIt.instance;

  await _registerCoreModules(sl);
}

Future<void> _registerCoreModules(GetIt sl) async {
  sl.registerSingleton<StorageService>(await StorageServiceImpl.instance(const FlutterSecureStorage()),dispose: (o) => o.dispose());
  sl.registerSingleton<Box>(await Hive.openBox("app"),instanceName: "app_box");
}