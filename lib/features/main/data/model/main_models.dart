import 'package:json_annotation/json_annotation.dart';
import 'package:tialink/features/main/domain/entities/main_entities.dart';

part 'main_models.g.dart';

@JsonSerializable(constructor: '_',explicitToJson: true)
class HomeModel extends Home {
  @JsonKey(name: "id")
  @override
  final String uuid;

  @override
  String label;

  @override
  final DeviceModel device;

  @override
  final List<DoorModel> doors;

  @JsonKey(name: "created_at")
  @override
  final DateTime? createdAt;

  @JsonKey(name: "updated_at")
  @override
  final DateTime? updatedAt;

  HomeModel._(this.uuid, this.label, this.createdAt, this.updatedAt, this.device, this.doors);
  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}

@JsonSerializable(constructor: '_')
class DeviceModel extends Device {
  @JsonKey(name: "id")
  @override
  final String uuid;

  @JsonKey(name: "mac_address")
  @override
  final String macAddress;

  @JsonKey(name: "master_id")
  @override
  final String masterId;

  @JsonKey(name: "created_at")
  @override
  final DateTime? createdAt;

  @JsonKey(name: "updated_at")
  @override
  final DateTime? updatedAt;

  DeviceModel._(this.uuid, this.macAddress, this.masterId, this.createdAt, this.updatedAt);
  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}

@JsonSerializable(constructor: '_')
class DoorModel extends Door {
  @JsonKey(name: "id")
  @override
  final String uuid;

  @JsonKey(name: "button_mode")
  @override
  final int buttonMode;

  @JsonKey(name: "home_id")
  @override
  final String homeId;

  @override
  final String label;

  @JsonKey(name: "created_at")
  @override
  final DateTime? createdAt;

  @JsonKey(name: "updated_at")
  @override
  final DateTime? updatedAt;

  DoorModel._(this.uuid, this.buttonMode, this.homeId, this.label, this.createdAt, this.updatedAt);
  factory DoorModel.fromJson(Map<String, dynamic> json) => _$DoorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoorModelToJson(this);
}
