import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:auth/model/api_result.dart';
import 'package:equatable/equatable.dart';

class APIException extends Equatable implements Exception {
  final int httpStatus;
  APIResult? apiResultError;
  APIValidationError? validationError;

  APIException(this.httpStatus, String body) {
    if (httpStatus == HttpStatus.unprocessableEntity) {
      validationError = APIValidationError.fromJson(jsonDecode(body));
    } else {
      apiResultError = APIResult.fromJsonString(body);
    }
  }

  @override
  List<Object?> get props => [httpStatus, apiResultError ?? validationError];
}

class APIValidationError extends Equatable {
  final String message;
  final Map<String, dynamic> errors;

  APIValidationError(this.message, this.errors);
  factory APIValidationError.fromJson(Map<String, dynamic> json) {
    return APIValidationError(json["message"], json["errors"]);
  }

  @override
  List<Object?> get props => [message, errors];
}
