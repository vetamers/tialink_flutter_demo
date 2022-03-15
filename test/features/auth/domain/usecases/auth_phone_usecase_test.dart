import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';
import 'package:tialink/features/auth/domain/entities/auth_phones_entities.dart';
import 'package:tialink/features/auth/domain/repositories/auth_repository.dart';
import 'package:tialink/features/auth/domain/usecases/auth_phone_usecase.dart';

import 'auth_phone_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  var repository = MockAuthRepository();
  RequestPhoneAuth requestPhoneAuth = RequestPhoneAuth(repository);
  PhoneAuthRequest testModel = PhoneAuthRequestModel.fake();

  group(
    "requestPhoneAuth",
    () {
      test(
        "Should return PhoneAuthRequest",
        () async {
          when(repository.requestPhoneVerification(any))
              .thenAnswer((realInvocation) async => Left(testModel));

          expect(await requestPhoneAuth.call(RequestPhoneAuthParams("phone")),
              Left(testModel));
        },
      );

      test("Should return InvalidRequestException", () async {
        when(repository.requestPhoneVerification(any))
            .thenAnswer((_) async => Right(InvalidRequestException(422, null)));
        expect(await requestPhoneAuth.call(RequestPhoneAuthParams("phone")),
            Right(InvalidRequestException(422, null)));

        verify(repository.requestPhoneVerification(any));
        verifyNoMoreInteractions(repository);
      });
    },
  );
}
