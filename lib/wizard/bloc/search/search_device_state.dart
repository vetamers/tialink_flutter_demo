part of 'search_device_bloc.dart';

enum SearchDeviceStatus{
  initial,
  permissionNeeded,
  permissionShowRequestRationale,
  permissionPermanentlyDenied,
  permissionDenied,
  permissionAccept,
}

class SearchDeviceState extends Equatable {
  final SearchDeviceStatus status;
  const SearchDeviceState(this.status);

  factory SearchDeviceState.permissionNeeded() => const SearchDeviceState(SearchDeviceStatus.permissionNeeded);
  factory SearchDeviceState.permissionAccepted() => const SearchDeviceState(SearchDeviceStatus.permissionAccept);
  factory SearchDeviceState.permissionDenied() => const SearchDeviceState(SearchDeviceStatus.permissionDenied);

  @override
  List<Object> get props => [status];

  @override
  String toString() {
    // TODO: implement toString
    return status.toString();
  }
}
