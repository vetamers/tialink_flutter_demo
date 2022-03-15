import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';
import 'package:tialink/features/auth/domain/entities/auth_phones_entities.dart';
import 'package:tialink/features/auth/domain/usecases/auth_phone_usecase.dart';
import 'package:tialink/features/auth/domain/usecases/auth_usecase.dart';
import 'package:tialink/features/auth/presentation/bloc/phone_auth_bloc.dart';

import 'auth_phone_bloc_test.mocks.dart';

@GenerateMocks([RequestPhoneAuth, LoginWithCredential])
void main() {
  var requestPhoneAuth = MockRequestPhoneAuth();
  var login = MockLoginWithCredential();
  var bloc = PhoneAuthBloc(requestPhoneAuth, login);
  PhoneAuthRequest testPhoneAuthRequest = PhoneAuthRequestModel.fake();
  AuthResult testAuthResult = AuthResult.fake();

  test(
    "Initial test",
    () {
      expect(bloc.isClosed, false);
      expect(bloc.state, PhoneAuthState.initial());
    },
  );

  group(
    "Normal flow",
    () {
      setUp(
        () {
          bloc = PhoneAuthBloc(requestPhoneAuth, login);
        },
      );

      setUpAll(
        () {
          when(requestPhoneAuth.call(any)).thenAnswer((_) async => Left(testPhoneAuthRequest));
          when(login.call(any)).thenAnswer((realInvocation) async => Left(testAuthResult));
        },
      );

      blocTest<PhoneAuthBloc, PhoneAuthState>(
          "Should emit [loading,requested] when PhoneAuthRequestEvent added",
          build: () => bloc,
          act: (b) => b.add(PhoneAuthRequestEvent(RequestPhoneAuthParams("123456789"))),
          expect: () => [
                PhoneAuthState.loading(PhoneAuthRequestEvent(RequestPhoneAuthParams("123456789"))),
                PhoneAuthState.requested(testPhoneAuthRequest),
              ],
          verify: (_) {
            verify(requestPhoneAuth.call(any)).called(1);
          });
    },
  );
}
