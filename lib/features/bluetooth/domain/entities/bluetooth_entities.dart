import 'package:equatable/equatable.dart';

enum RemoteButton { a, b, c, d }

enum RemoteSetupStatus { waitingForAction, signalReceived, operationDone }

class RemoteSetupState extends Equatable {
  final int totalStep;
  final int step;
  final String secret;
  final RemoteSetupStatus status;

  const RemoteSetupState(this.totalStep, this.step, this.secret, this.status);

  @override
  List<Object?> get props => [totalStep, step, status];
}
