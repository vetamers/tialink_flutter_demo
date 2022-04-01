import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';

import '../../domain/usecases/main_usecase.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final GetHomes _getHomesUsecase;

  MainBloc(this._getHomesUsecase) : super(MainState.initial()) {
    on<GetHomesEvent>(_getHomes);
  }

  void _getHomes(GetHomesEvent event, Emitter<MainState> emit) async {
    emit(MainState.loading(event));
    (await _getHomesUsecase(event.param)).fold((l) => emit(MainState.done(event, l)),
        (r) => emit(MainState.error(event, r)));
  }
}
