import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:auth/model/api_result.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_error.g.dart';

class APIException extends Equatable implements Exception {
  final int httpStatus;
  APIResult? apiResultError;
  APIValidationError? validationError;

  APIException(this.httpStatus, String body) {
    if (httpStatus == HttpStatus.unprocessableEntity) {
      validationError = APIValidationError.fromJson(jsonDecode(body));
    } else {
      apiResultError = APIResult.fromJson(jsonDecode(body));
    }
  }

  @override
  List<Object?> get props => [httpStatus, apiResultError ?? validationError];
}

@JsonSerializable(createToJson: false)
class APIValidationError{
  late String message;
  late Map<String, Map<String,List<String>>> errors;

  APIValidationError();

  factory APIValidationError.fromJson(Map<String,dynamic> json) => _$APIValidationErrorFromJson(json);
}
