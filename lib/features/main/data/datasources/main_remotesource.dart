import 'package:dio/dio.dart';
import 'package:tialink/core/exceptions/api_exceptions.dart';
import 'package:tialink/features/main/data/model/api_model.dart';
import 'package:tialink/features/main/data/model/main_models.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';

abstract class MainRemoteSource {
  Future<HomeModel> getHome(String id);
  Future<List<HomeModel>> getHomes();

  Future<APIResultModel> addHome({required String label, required String deviceId});

  Future<APIResultModel> addFirstHome(
      {required String label,
      required String deviceMacAddress,
      required String deviceSecret,
      String doorLabel = "Main",
      required int buttonMode});

  Future<APIResultModel> editHome({required Home home});

  Future<APIResultModel> addDoor({required String homeId, required String doorLabel, required int buttonMode});
  Future<APIResultModel> editDoor({required Door door});
}

class MainRemoteSourceImpl implements MainRemoteSource {
  final Dio _dio;

  MainRemoteSourceImpl(this._dio);

  @override
  Future<HomeModel> getHome(String id) async {
    var response = await _dio.get('homes/$id');

    if (response.statusCode == 200) {
      return HomeModel.fromJson(response.data);
    } else {
      throw APIException.from(response);
    }
  }

  @override
  Future<List<HomeModel>> getHomes() async {
    var response = await _dio.get('homes');

    if (response.statusCode == 200) {
      return (response.data as List<dynamic>).map((e) => HomeModel.fromJson(e)).toList();
    } else {
      throw APIException.from(response);
    }
  }

  @override
  Future<APIResultModel> addHome({required String label, required String deviceId}) async {
    var response = await _dio.post('homes', data: {"label": label, "device_id": deviceId});

    if (response.statusCode == 201) {
      return APIResultModel.fromJson(response.data);
    } else {
      throw APIException.from(response);
    }
  }

  @override
  Future<APIResultModel> addFirstHome(
      {required String label,
      required String deviceMacAddress,
      required String deviceSecret,
      String doorLabel = "Main",
      required int buttonMode}) async {
    var response = await _dio.post('homes', data: {
      "label": label,
      "device": {
        "mac_address": deviceMacAddress,
        "secret": deviceSecret,
      },
      "door": {"label": doorLabel, "button_mode": "$buttonMode"}
    });

    if (response.statusCode == 201) {
      return APIResultModel.fromJson(response.data);
    } else {
      throw APIException.from(response);
    }
  }

  @override
  Future<APIResultModel> editHome({required Home home}) async {
    var response = await _dio.put('homes/${home.uuid}',data: {"label": home.label});

    if (response.statusCode == 200) {
      return APIResultModel.fromJson(response.data);
    }else{
      throw APIException.from(response);
    }
  }

  @override
  Future<APIResultModel> editDoor({required Door door}) {
    // TODO: implement editDoor
    throw UnimplementedError();
  }

  @override
  Future<APIResultModel> addDoor({required String homeId, required String doorLabel, required int buttonMode}) async {
    var response = await _dio.post('homes/$homeId/doors',data: {
      "label": doorLabel,
      "button_mode": buttonMode
    });

    if (response.statusCode == 200) {
      return APIResultModel.fromJson(response.data);
    }else{
      throw APIException.from(response);
    }
  }

}
