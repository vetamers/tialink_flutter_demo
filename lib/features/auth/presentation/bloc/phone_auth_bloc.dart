import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';
import 'package:tialink/features/auth/domain/entities/auth_phones_entities.dart';
import 'package:tialink/features/auth/domain/usecases/auth_phone_usecase.dart';
import 'package:tialink/features/auth/domain/usecases/auth_usecase.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final RequestPhoneAuth requestPhoneAuth;
  final LoginWithCredential getToken;

  PhoneAuthBloc(this.requestPhoneAuth,this.getToken) : super(PhoneAuthState.initial()) {
    on<PhoneAuthRequestEvent>(_request);
    on<PhoneAuthTryCredential>(_tryCredential);
  }

  void _request(PhoneAuthRequestEvent event, Emitter<PhoneAuthState> emit) async {
    _loading(event, emit);
    var response = await requestPhoneAuth(event.params);
    response.fold((l) => emit(PhoneAuthState.requested(l)), (r) => emit(PhoneAuthState.requestFailed(r)));
  }

  void _tryCredential(PhoneAuthTryCredential event, Emitter<PhoneAuthState> emit) async {
    _loading(event, emit);
    var response = await getToken(LoginParam(PhoneAuthCredentialModel(event.authRequest.requestId,event.smsCode),"Test"));
    response.fold((l) => emit(PhoneAuthState.credentialAccept()), (r) => emit(PhoneAuthState.invalidCredential(event)));
  }

  void _loading(PhoneAuthEvent event,Emitter<PhoneAuthState> emit) => emit(PhoneAuthState.loading(event));
}
