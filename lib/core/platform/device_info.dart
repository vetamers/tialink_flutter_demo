import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

abstract class DeviceInfo {
  String get deviceModel;
  String get osVersion;
}

class DeviceInfoImpl implements DeviceInfo {
  final dynamic _deviceInfo;

  DeviceInfoImpl._(this._deviceInfo);

  static Future<DeviceInfoImpl> init(DeviceInfoPlugin plugin) async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return DeviceInfoImpl._(await plugin.androidInfo);
      case TargetPlatform.iOS:
        return DeviceInfoImpl._(await plugin.iosInfo);
      default:
        throw UnsupportedError("Unsupported platform ${defaultTargetPlatform.name}");
    }
  }

  String _deviceModel() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return (_deviceInfo as AndroidDeviceInfo).model!;
      case TargetPlatform.iOS:
        return (_deviceInfo as IosDeviceInfo).utsname.machine!;
      default:
        throw UnsupportedError("Unsupported platform ${defaultTargetPlatform.name}");
    }
  }

  String _osVersion() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return "API " + (_deviceInfo as AndroidDeviceInfo).version.sdkInt.toString();
      case TargetPlatform.iOS:
        return (_deviceInfo as IosDeviceInfo).systemVersion!;
      default:
        throw UnsupportedError("Unsupported platform ${defaultTargetPlatform.name}");
    }
  }

  @override
  String toString() => "$deviceModel/$osVersion";

  @override
  String get deviceModel => _deviceModel();

  @override
  String get osVersion => _osVersion();
}
