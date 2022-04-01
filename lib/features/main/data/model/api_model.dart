import 'package:json_annotation/json_annotation.dart';
import 'package:tialink/features/main/domain/entities/api_entity.dart';

part 'api_model.g.dart';

@JsonSerializable(createToJson: false, constructor: '_')
class APIResultModel extends APIResult {
  @JsonKey(name: "ok")
  @override
  final bool isSuccessful;

  @override
  final String? message;

  APIResultModel._(this.isSuccessful, this.message);
  factory APIResultModel.fromJson(Map<String, dynamic> json) => _$APIResultModelFromJson(json);
}