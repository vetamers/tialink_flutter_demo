import 'package:equatable/equatable.dart';

abstract class APIResult extends Equatable {
  bool get isSuccessful;
  String? get message;

  @override
  List<Object?> get props => [isSuccessful,message];
}