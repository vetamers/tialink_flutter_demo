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

    });
  }


}
