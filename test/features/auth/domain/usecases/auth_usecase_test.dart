import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';
import 'package:tialink/features/auth/domain/repositories/auth_repository.dart';
import 'package:tialink/features/auth/domain/usecases/auth_usecase.dart';

import 'auth_phone_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  var repository = MockAuthRepository();
  LoginWithCredential createToken = LoginWithCredential(repository);
  AuthResult testAuthResult = AuthResult.fake();
  var testPhoneAuthCredential = PhoneAuthCredentialModel("verificationId", "1234");

  group(
    "createToken",
    () {
      test(
        "Should return Right(AuthResult)",
        () async {
          when(repository.createToken(any, any)).thenAnswer(((_) async => Left(testAuthResult)));

          expect(await createToken.call(LoginParam(testPhoneAuthCredential, "deviceName")),
              Left(testAuthResult));
          verify(repository.createToken(any, any));
          verifyNoMoreInteractions(repository);
        },
      );

      test(
        "Should return Left(APIException)",
        () async {
          when(repository.createToken(any, any)).thenThrow(InvalidRequestException(401, {}));

          expect(() async => await createToken.call(LoginParam(testPhoneAuthCredential, "deviceName")),
              throwsA(isA<InvalidRequestException>()));
        },
      );
    },
  );
}
