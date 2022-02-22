part of 'search_device_bloc.dart';

enum SearchDeviceEvents{
  checkPermission,
  showPermissionDialog
}

class SearchDeviceEvent extends Equatable {
  final SearchDeviceEvents e;
  const SearchDeviceEvent(this.e);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return e.name;
  }
}
