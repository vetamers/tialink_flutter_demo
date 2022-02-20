import 'dart:convert';

import 'package:equatable/equatable.dart';

class APIResult extends Equatable {
  final bool isSuccessful;
  final String? message;

  APIResult(this.isSuccessful, this.message);

  factory APIResult.fromJson(Map<String, dynamic> json) {
    return APIResult(json["ok"], json["message"]);
  }

  factory APIResult.fromJsonString(String json) {
    return APIResult.fromJson(jsonDecode(json));
  }

  @override
  List<Object?> get props => [isSuccessful, message];
}
