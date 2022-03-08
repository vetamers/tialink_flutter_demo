import 'package:auth/model/api_result.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

class APIResultWithCallBack<T> extends APIResult {
  late T callback;

  APIResultWithCallBack();

  factory APIResultWithCallBack.fromJson(Map<String, dynamic> json) {
    return APIResultWithCallBack()
      ..isSuccessful = json["ok"] as bool
      ..callback = json["callback"] as T;
  }

  @override
  String toString() {
    return "{$isSuccessful,$callback}";
  }
}

@JsonSerializable(createToJson: false)
class Device extends Equatable {
  late String id;

  @JsonKey(name: "master_id")
  late String masterId;

  @JsonKey(name: "mac_address")
  late String macAddress;

  Device();
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  @override
  List<Object?> get props => [id];
}

@JsonSerializable(createToJson: false)
class Door extends Equatable {
  late String id;

  @JsonKey(name: "home_id")
  late String homeId;

  late String label;

  @JsonKey(name: "button_mode")
  late int buttonMode;

  Door();

  factory Door.fromJson(Map<String, dynamic> json) => _$DoorFromJson(json);

  @override
  List<Object?> get props => [id];
}

@JsonSerializable(createToJson: false)
class Home extends Equatable {
  late String id;
  late String label;
  late Device device;

  @JsonKey(name: "doors")
  late List<Door> doorList;

  Home();

  factory Home.fromJson(Map<String, dynamic> json) => _$HomeFromJson(json);

  @override
  List<Object?> get props => [id];
}
