part of 'permission_bloc.dart';

abstract class PermissionEvent extends Equatable {
  const PermissionEvent();

  @override
  List<Object> get props => [];
}

class PermissionCheckEvent extends PermissionEvent {
  final Permission permission;

  const PermissionCheckEvent(this.permission);

  @override
  List<Object> get props => [permission.toString()];
}

class PermissionRequestEvent extends PermissionEvent {
  final Permission permission;

  const PermissionRequestEvent(this.permission);

  @override
  List<Object> get props => [permission.toString()];
}
