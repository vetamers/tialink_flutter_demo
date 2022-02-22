import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    log("Bloc observer : $event");
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    log("Bloc observer: $bloc changed to ${change.nextState.toString()}");
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    log("Bloc observer: created - ${bloc}");
  }
}
