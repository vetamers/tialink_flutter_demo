import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

abstract class AuthCredential extends Equatable {
  String get providerId;
  String get signInMethod;
  Map<String, dynamic> get payload;

  @override
  List<Object> get props => [providerId, signInMethod, payload];

  Map<String, dynamic> toJson();
}

@JsonSerializable(constructor: '_')
class User extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final List<String> providers;

  const User._(
      this.id, this.name, this.email, this.phone, this.emailVerifiedAt, this.phoneVerifiedAt, this.providers);

  @override
  List<Object?> get props => [id];

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @visibleForTesting
  static User fake() {
    return User._("id", "name", "email", "phone", DateTime.now(), DateTime.now(), const ["provider"]);
  }
}

@JsonSerializable(constructor: '_')
class AuthResult extends Equatable {
  final String token;
  final User user;

  @JsonKey(name: "expire_at")
  final DateTime expireAt;

  @override
  List<Object?> get props => [token];

  const AuthResult._(this.token, this.user, this.expireAt);

  factory AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResultToJson(this);

  @visibleForTesting
  static AuthResult fake({bool expire = false}) {
    var now = DateTime.now();
    return AuthResult._(
        "token",
        User.fake(),
        expire ? DateTime.utc(now.year - 1) : DateTime.utc(now.year + 1)
    );
  }
}
