import 'dart:convert';

import 'package:auth/service/user_service.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  late String id;
  String? name;
  String? email;
  String? phone;
  DateTime? emailVerifiedAt;
  DateTime? phoneVerifiedAt;
  late List<String> providers;

  User();

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String,dynamic> toJson() => _$UserToJson(this);
}
