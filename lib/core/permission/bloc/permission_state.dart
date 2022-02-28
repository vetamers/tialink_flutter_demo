part of 'permission_bloc.dart';

enum PermissionStatus {
  initial,
  denied,
  granted,
  shouldShowRequestRationale,
  permanentlyDenied
}

@immutable
class PermissionState extends Equatable {
  final PermissionStatus value;

  const PermissionState(this.value);

  @override
  List<Object?> get props => [value];
}
