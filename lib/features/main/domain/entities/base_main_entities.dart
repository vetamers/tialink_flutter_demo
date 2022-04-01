import 'package:equatable/equatable.dart';

abstract class BaseEntity extends Equatable {
  String get uuid;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  @override
  List<Object?> get props => [uuid];
}