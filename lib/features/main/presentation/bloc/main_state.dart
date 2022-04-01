part of 'main_bloc.dart';

enum MainStatus { initial, loading, done, error }

class MainState extends Equatable {
  final MainStatus value;
  final Map<String, dynamic> metadata;

  @override
  List<Object?> get props => [value, metadata];

  const MainState._(this.value, [this.metadata = const {}]);

  factory MainState.initial() => const MainState._(MainStatus.initial);
  factory MainState.loading(MainEvent event) => MainState._(MainStatus.loading, {"event": event});
  factory MainState.done(MainEvent event, dynamic data) =>
      MainState._(MainStatus.done, {"event": event, "data": data});
  factory MainState.error(MainEvent event, APIException exception) =>
      MainState._(MainStatus.error, {"event": event, "error": exception});
}
