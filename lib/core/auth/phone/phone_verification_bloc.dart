import 'dart:async';

import 'package:auth/auth.dart';
import 'package:auth/core/api_error.dart';
import 'package:auth/model/api_result.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'phone_verification_event.dart';
part 'phone_verification_state.dart';

class PhoneVerificationBloc
    extends Bloc<PhoneVerificationEvent, PhoneVerificationState> {
  final PhoneAuthProvider _provider = PhoneAuthProvider();

  PhoneVerificationBloc() : super(PhoneVerificationState.initial()) {
    on<PhoneVerificationRequestEvent>(_requestCode);
    on<PhoneVerificationTryCodeEvent>(_tryCode);
  }

  FutureOr<void> _requestCode(PhoneVerificationRequestEvent event,
      Emitter<PhoneVerificationState> emit) async {
    try {
      emit(PhoneVerificationState.requested(await _provider.verificationRequest(event.phone)));
    } on APIException catch (e) {
      emit(PhoneVerificationState.error(e, event));
    }
  }

  FutureOr<void> _tryCode(PhoneVerificationTryCodeEvent event,
      Emitter<PhoneVerificationState> emit) async {
    try {
      var phoneCredential = _provider.getCredential(event.verificationId, event.smsCode);
      emit(PhoneVerificationState.done(await Authenticator.instance.signInWithCredential(phoneCredential)));
    } on APIException catch (e) {
      emit(PhoneVerificationState.invalidCredential(e));
    }
  }
}
