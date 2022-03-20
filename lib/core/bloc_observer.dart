import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class Observer extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log("$bloc change to $change");
    super.onChange(bloc, change);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    log("$event for $bloc");
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    log("$bloc created");
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    log("$bloc closed");
    super.onClose(bloc);
  }
}
