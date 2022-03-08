import 'dart:convert';
import 'dart:developer';

import 'package:auth/core/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:tialink/data/models.dart';
import 'package:tialink/data/provider/provider.dart';

class DeviceProvider extends DataProvider {
  DeviceProvider() : super(HttpHelper("devices"));

  Future<List<Device>> getDevice() async {
    try {
      var response = await http.get("/");

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body) as List<dynamic>;
        return json.map((e) => Device.fromJson(e)).toList();
      } else {
        return Future.error(ErrorDescription("HttpCode: ${response.statusCode}"));
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<APIResultWithCallBack<String>> addDevice(String macAddress,String secret) async {
    try {
      var response = await http.post("/", {"mac_address": macAddress, "secret": secret});

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
}
