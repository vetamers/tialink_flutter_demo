import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tialink/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';
import 'package:tialink/features/auth/data/repositories/auth_phone_repository_impl.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([AuthRemoteSource, AuthLocalSource])
void main() {
  var remoteSource = MockAuthRemoteSource();
  var localSource = MockAuthLocalSource();
  AuthRepositoryImpl repository = AuthRepositoryImpl(remoteSource, localSource);
  PhoneAuthRequestModel testModel = PhoneAuthRequestModel.fake();
  AuthResult testAuthResult = AuthResult.fake();
  var testPhoneAuthCredential = PhoneAuthCredentialModel("verificationId", "1234");

  group("requestPhoneVerification", () {
    test(
      "Should return PhoneVerificationRequest",
      () async {
        when(remoteSource.requestPhoneVerification(any)).thenAnswer((_) async => testModel);

        expect(await repository.requestPhoneVerification("phone"), equals(Left(testModel)));
        verify(remoteSource.requestPhoneVerification(any));
        verifyNoMoreInteractions(remoteSource);
      },
    );

    test("Should return InvalidRequestException", () async {
      when(remoteSource.requestPhoneVerification(any)).thenThrow(InvalidRequestException(422, {}));

      expect(await repository.requestPhoneVerification("phone"),
          equals(Right(InvalidRequestException(422, {}))));
      verify(remoteSource.requestPhoneVerification(any));
      verifyNoMoreInteractions(remoteSource);
    });
  });

  group(
    "createToken",
    () {
      test("Should return AuthResult", () async {
        when(remoteSource.createToken(any, any)).thenAnswer((_) async => testAuthResult);

        expect(await repository.createToken(testPhoneAuthCredential, "deviceName"), Left(testAuthResult));
        verifyInOrder([remoteSource.createToken(any, any), localSource.saveAuthCertificate(any)]);
        verifyNoMoreInteractions(remoteSource);
      });

      group("getToken", () {
        test(
          "Should return AuthResult",
          () {
            when(localSource.getAuthCertificate()).thenReturn(AuthResult.fake());

            expect(repository.getToken(), Left(AuthResult.fake()));

            verify(localSource.getAuthCertificate());
            verifyNoMoreInteractions(localSource);
          },
        );
      });
    },
  );
}
