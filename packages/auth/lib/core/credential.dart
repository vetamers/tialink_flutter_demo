import 'package:equatable/equatable.dart';

abstract class AuthCredential extends Equatable {
  String get providerId;
  String get signInMethod;
  Map<String,dynamic> get payload;

  @override
  List<Object?> get props => [providerId, signInMethod];

  Map<String,dynamic> toJson();
}
