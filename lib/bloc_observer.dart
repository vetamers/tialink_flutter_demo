import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    log("Bloc observer: $bloc - $change");
    super.onChange(bloc, change);
  }
}
