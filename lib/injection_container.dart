import 'package:device_info_plus/device_info_plus.dart' as device_info_plugin;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tialink/core/platform/device_info.dart';
import 'package:tialink/core/services/net_service.dart';
import 'package:tialink/core/services/storage_service.dart';
import 'package:tialink/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tialink/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tialink/features/auth/data/repositories/auth_phone_repository_impl.dart';
import 'package:tialink/features/auth/domain/repositories/auth_repository.dart';
import 'package:tialink/features/auth/domain/usecases/auth_phone_usecase.dart';
import 'package:tialink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:tialink/features/auth/presentation/bloc/phone_auth_bloc.dart';
import 'env.dart';

Future<void> initInjector() async {
  final GetIt sl = GetIt.instance;

  await _registerCoreModules(sl);

  _registerAuthFeature(sl);
}

Future<void> _registerCoreModules(GetIt sl) async {
  sl.registerSingleton(await PackageInfo.fromPlatform());
  sl.registerSingleton<DeviceInfo>(await DeviceInfoImpl.init(device_info_plugin.DeviceInfoPlugin()));

  sl.registerSingleton<StorageService>(await StorageServiceImpl.instance(const FlutterSecureStorage()),
      dispose: (o) => o.dispose());

  sl.registerSingleton<NetService>(NetServiceImpl(sl(), sl(), apiUrl: API.apiBaseUrl));
  sl.registerSingleton<Dio>(sl<NetService>().dio);

  sl.registerSingleton<Box>(await Hive.openBox("app"), instanceName: "app_box");
  sl.registerSingleton<Box>(await sl<StorageService>().secureBox("auth"), instanceName: "auth_box");
}

Future<void> _registerAuthFeature(GetIt sl) async {
  sl.registerLazySingleton<AuthLocalSource>(() => AuthLocalSourceImpl(sl(instanceName: "auth_box")));
  sl.registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton(() => RequestPhoneAuth(sl()));
  sl.registerLazySingleton(() => LoginWithCredential(sl()));

  sl.registerFactory(() => PhoneAuthBloc(sl(), sl()));
}
