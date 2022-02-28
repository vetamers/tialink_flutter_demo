part of 'permission_bloc.dart';

enum PermissionEvents {
  checkPermission,
  requestPermission,
}

@immutable
class PermissionEvent extends Equatable {
  final PermissionEvents value;
  final int permissionCode;

  const PermissionEvent._(this.value,this.permissionCode);

  factory PermissionEvent.checkPermission(int permissionCode) => PermissionEvent._(PermissionEvents.checkPermission, permissionCode);
  factory PermissionEvent.requestPermission(int permissionCode) => PermissionEvent._(PermissionEvents.requestPermission, permissionCode);

  @override
  List<Object?> get props => [value];
}
