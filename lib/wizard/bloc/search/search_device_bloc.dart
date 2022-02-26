import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tialink/bluetooth/bluetooth_bloc.dart';

part 'search_device_event.dart';
part 'search_device_state.dart';

class SearchDeviceBloc extends Bloc<SearchDeviceEvent, SearchDeviceState> {

  final BluetoothBloc _bluetoothBloc;

  SearchDeviceBloc(this._bluetoothBloc) : super(const SearchDeviceState(SearchDeviceStatus.initial)) {

    on<SearchDeviceEvent>((event, emit) {
      switch (event.e){
        case SearchDeviceEvents.showPermissionDialog:
          return _requestPermission(event,emit);
        case SearchDeviceEvents.checkPermission:
          return _checkPermission(event,emit);
      }
    });
  }

  Future<void> _checkPermission(SearchDeviceEvent event,Emitter emitter) async {
    if (await Permission.location.isDenied){
      if(await Permission.location.shouldShowRequestRationale){
        emitter(const SearchDeviceState(SearchDeviceStatus.permissionShowRequestRationale));
      }else{
        emitter(SearchDeviceState.permissionDenied());
      }
    }else{
      emitter(SearchDeviceState.permissionAccepted());
      _bluetoothBloc.add(BluetoothDiscoveryEvent());
    }
  }

  Future<void> _requestPermission(SearchDeviceEvent event,Emitter emitter) async {
    var request = await Permission.location.request();

    if (request == PermissionStatus.granted){
      emitter(SearchDeviceState.permissionAccepted());
    }else if (request == PermissionStatus.permanentlyDenied){
      emitter(const SearchDeviceState(SearchDeviceStatus.permissionPermanentlyDenied));
    }else{
      emitter(SearchDeviceState.permissionDenied());
    }
  }
}
