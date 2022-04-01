part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();

  @override
  List<Object?> get props => [];
}

class GetHomesEvent extends MainEvent {
  final GetHomeParam param;

  const GetHomesEvent(this.param);

  @override
  List<Object?> get props => [param];
}
