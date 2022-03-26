import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionState> {
  PermissionBloc() : super(PermissionState.initial()) {
    on<PermissionCheckEvent>(_checkPermission);
    on<PermissionRequestEvent>(_requestPermission);
  }

  void _checkPermission(PermissionCheckEvent event, Emitter<PermissionState> emit) async {
    if (await event.permission.isDenied) {
      if (await event.permission.shouldShowRequestRationale) {
        emit(PermissionState.shouldShowRequestRationale(event.permission));
      } else {
        emit(PermissionState.denied(event.permission));
      }
    } else {
      emit(PermissionState.granted(event.permission));
    }
  }

  void _requestPermission(PermissionRequestEvent event, Emitter<PermissionState> emit) async {
    var result = await event.permission.request();

    if (result.isGranted) {
      emit(PermissionState.granted(event.permission));
    } else if (result.isPermanentlyDenied) {
      emit(PermissionState.permanentlyDenied(event.permission));
    } else {
      emit(PermissionState.denied(event.permission));
    }
  }
}
