import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tialink/features/auth/data/models/auth_phone_models.dart';

void main() {
  Dio dio = Dio();
  DioAdapter dioAdapter = DioAdapter(dio: dio);
  dio.options.validateStatus = (_) => true;
  AuthRemoteSourceImpl remoteSource = AuthRemoteSourceImpl(dio);
  var testPhoneAuthRequestModel = PhoneAuthRequestModel.fake();

  group(
    "PhoneAuthRequest",
    () {
      group("Successful response tests", () {
        test("Should phone auth request return PhoneAuthRequestModel",
            () async {
          dioAdapter.onPost("auth/provider/phone/request", (server) {
            server.reply(201, testPhoneAuthRequestModel.toJson());
          }, data: {"phone": "1234567890"});
          var response =
              await remoteSource.requestPhoneVerification("1234567890");

          expect(response, equals(testPhoneAuthRequestModel));
        });
      });

      group("Failed response tests", () {
        test("Should throw InvalidRequestException", () async {
          dioAdapter.onPost("auth/provider/phone/request", (server) {
            server.reply(422, null);
          }, data: {"phone": "1234567890"});

          expect(
              () async =>
                  await remoteSource.requestPhoneVerification("1234567890"),
              throwsA(isA<InvalidRequestException>()));
        });
      });
    },
  );
}
