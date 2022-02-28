import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(const PermissionState(PermissionStatus.initial)) {
    on<PermissionEvent>((event, emit) {
      switch (event.value){
        case PermissionEvents.checkPermission:
          return _checkPermission(event,emit);
        case PermissionEvents.requestPermission:
          return _requestPermission(event, emit);
      }
    });
  }

  Future<void> _checkPermission(PermissionEvent event, Emitter<PermissionState> emit) async {
    var permission = Permission.byValue(event.permissionCode);

    if (await permission.isDenied){
      if(await permission.shouldShowRequestRationale){
        emit(const PermissionState(PermissionStatus.shouldShowRequestRationale));
      }else{
        emit(const PermissionState(PermissionStatus.denied));
      }
    }else{
      emit(const PermissionState(PermissionStatus.granted));
    }
  }

  Future<void> _requestPermission(PermissionEvent event,Emitter emit) async {
    var permission = _getPermissionFromInt(event.permissionCode);
    var request = await permission.request();

    if (request.isGranted){
      emit(const PermissionState(PermissionStatus.granted));
    }else if (request.isPermanentlyDenied){
      emit(const PermissionState(PermissionStatus.permanentlyDenied));
    }else{
      emit(const PermissionState(PermissionStatus.denied));
    }
  }

  Permission _getPermissionFromInt(int permissionCode) => Permission.byValue(permissionCode);

}
