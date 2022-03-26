part of 'permission_bloc.dart';

enum PermissionStatus { initial, denied, granted, shouldShowRequestRationale, permanentlyDenied }

class PermissionState extends Equatable {
  final PermissionStatus value;
  final Permission? permission;

  @override
  List<Object?> get props => [value,permission.toString()];

  const PermissionState._(this.value, this.permission);

  factory PermissionState.initial() => const PermissionState._(PermissionStatus.initial, null);
  factory PermissionState.denied(Permission permission) =>
      PermissionState._(PermissionStatus.denied, permission);
  factory PermissionState.granted(Permission permission) =>
      PermissionState._(PermissionStatus.granted, permission);
  factory PermissionState.shouldShowRequestRationale(Permission permission) =>
      PermissionState._(PermissionStatus.shouldShowRequestRationale, permission);
  factory PermissionState.permanentlyDenied(Permission permission) =>
      PermissionState._(PermissionStatus.permanentlyDenied, permission);
}
