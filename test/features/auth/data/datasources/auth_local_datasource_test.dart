import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tialink/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tialink/features/auth/data/models/auth_models.dart';
import 'package:tialink/features/auth/exceptions/auth_exceptions.dart';

import 'auth_local_datasource_test.mocks.dart';

@GenerateMocks([Box])
void main() {
  var box = MockBox();
  var dataSource = AuthLocalSourceImpl(box);

  group(
    "getAuthCertificate",
    () {
      test("Should return AuthResult", () {
        when(box.containsKey("certificate")).thenReturn(true);
        when(box.get("certificate"))
            .thenReturn(jsonEncode(AuthResult.fake().toJson()));

        expect(dataSource.getAuthCertificate(), AuthResult.fake());

        verifyInOrder([box.containsKey("certificate"), box.get("certificate")]);

        verifyNoMoreInteractions(box);
      });

      test("Should throw errorUserTokenNotFound", () {
        when(box.containsKey("certificate")).thenReturn(false);

        expect(() => dataSource.getAuthCertificate(),
            throwsA(AuthInvalidUserException.errorUserTokenNotFound()));

        verify(box.containsKey("certificate"));
        verifyNever(box.get(any));
        verifyNoMoreInteractions(box);
      });

      test("Should throw errorUserTokenExpire", () {
        when(box.containsKey("certificate")).thenReturn(true);
        when(box.get("certificate"))
            .thenReturn(jsonEncode(AuthResult.fake(expire: true).toJson()));

        expect(() => dataSource.getAuthCertificate(),
            throwsA(AuthInvalidUserException.errorUserTokenExpire()));

        verifyInOrder([box.containsKey("certificate"), box.get("certificate")]);
        verifyNoMoreInteractions(box);
      });

      test("Should save AuthResult", () async {
        when(box.put("certificate", any)).thenAnswer(
            (realInvocation) async => jsonEncode(AuthResult.fake().toJson()));

        expect(
            () async => await dataSource.saveAuthCertificate(AuthResult.fake()),
            returnsNormally);
        verify(box.put("certificate", any));
        verifyNoMoreInteractions(box);
      });
    },
  );
}
