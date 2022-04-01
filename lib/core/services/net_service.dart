import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tialink/core/platform/device_info.dart';
import 'package:tialink/features/auth/domain/repositories/auth_repository.dart';

abstract class NetService {
  Dio get dio;
}

class NetServiceImpl implements NetService {
  final DeviceInfo _deviceInfo;
  final PackageInfo _packageInfo;
  final String apiUrl;

  Dio? _dio;

  NetServiceImpl(this._deviceInfo, this._packageInfo, {required this.apiUrl});

  Dio _getDioClient() {
    if (_dio != null) return _dio!;

    var dio = Dio(BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: 5000,
        sendTimeout: 3000,
        receiveTimeout: 3000,
        validateStatus: (c) => c! <= 500,
        headers: {"accept": "application/json", "user-agent": _generateUserAgentString()}));

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
          requestHeader: false, responseHeader: false, responseBody: true, logPrint: (_) => log));
    }

    return dio;
  }

  String _generateUserAgentString() {
    return "${_packageInfo.appName}/${_packageInfo.version} - $_deviceInfo";
  }

  @override
  Dio get dio => _getDioClient();
}

class AuthInterceptor extends Interceptor {
  final AuthRepository _authRepository;

  AuthInterceptor(this._authRepository);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var certificate = _authRepository.getToken();

    certificate.fold((l) {
      options.headers.addAll({HttpHeaders.authorizationHeader: "Bearer ${l.token}"});
    }, (r) => null);

    super.onRequest(options, handler);
  }
}
