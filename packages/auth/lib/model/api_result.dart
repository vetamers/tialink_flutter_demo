import 'dart:convert';

import 'package:auth/model/user.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_result.g.dart';

@JsonSerializable(createToJson: false)
class APIResult {
  @JsonKey(name: "ok")
  late bool isSuccessful;
  String? message;

  APIResult();

  factory APIResult.fromJson(Map<String, dynamic> json) => _$APIResultFromJson(json);
}

class AuthResult extends Equatable {
  final User user;

  const AuthResult(this.user);

  @override
  List<Object?> get props => [user];
}
