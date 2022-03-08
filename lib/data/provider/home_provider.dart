import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auth/auth.dart';
import 'package:auth/model/api_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:tialink/data/models.dart';
import 'package:tialink/data/provider/provider.dart';

class HomeProviders extends DataProvider {
  HomeProviders() : super(HttpHelper("homes"));

  Future<List<Home>> getHomes() async {
    try {
      var response = await http.get("/");

      if (response.statusCode == HttpStatus.ok) {
        var json = jsonDecode(response.body) as List<dynamic>;
        var data = json.map((e) => Home.fromJson(e)).toList();
        return Future.value(data);
      } else {
        log("HttpCode: ${response.statusCode}");
        return Future.error(ErrorDescription("HttpCode: ${response.statusCode}"));
      }
    } catch (e) {
      log("Error: ", error: e);
      return Future.error(e);
    }
  }

  Future<APIResultWithCallBack<String>> addHome(String label, String deviceId) async {
    try {
      var response = await http.post("/", {"label": label, "device_id": deviceId});
      if (response.statusCode == 200) {
        return APIResultWithCallBack.fromJson(jsonDecode(response.body));
      } else {
        return Future.error(ErrorDescription("HttpCode: ${response.statusCode}"));
      }
    } catch (e) {
      log("Error", error: e);
      return Future.error(e);
    }
  }

  Future<APIResult> quickSave(String homeLabel, String doorLabel, String deviceMacAddress,
      String deviceSecret, String buttonMode) async {
    var body = {
      "label": homeLabel,
      "device": {"mac_address": deviceMacAddress, "secret": deviceSecret},
      "door": {"label": doorLabel, "button_mode": buttonMode}
    };
    try {
      var response = await http.post("/", body);

      if (response.statusCode == 201) {
        return Future.value(APIResult.fromJson(jsonDecode(response.body)));
      } else {
        return Future.error(ErrorDescription("Http status code: ${response.statusCode}"));
      }
    } catch (e) {
      log("Error in home_provider:", error: e);
      return Future.error(e);
    }
  }
}
