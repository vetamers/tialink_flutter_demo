import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class APIException extends ErrorDescription {
  final String message;

  APIException(this.message) : super(message);

  @override
  bool operator ==(Object other) => other is APIException;

  @override
  int get hashCode => message.hashCode;

  static APIException from(Response<dynamic> response) {
    assert(response.statusCode != null);
    switch (response.statusCode) {
      default:
        return InvalidRequestException(response.statusCode!, response.data);
    }
  }
}

class InvalidRequestException extends APIException {
  final int statusCode;
  final dynamic data;

  InvalidRequestException(this.statusCode, this.data) : super('HTTP $statusCode\nData: $data');
}
