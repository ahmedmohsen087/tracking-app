import 'package:flowery_rider_app/features/auth/data/models/driver_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "driver")
  final Driver? driver;
  @JsonKey(name: "token")
  final String? token;

  @JsonKey(name: "info")
  final String? info;
  @JsonKey(name: "status")
  final String? status;

  const AuthResponseModel({
    this.message,
    this.driver,
    this.token,
    this.info,
    this.status,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
