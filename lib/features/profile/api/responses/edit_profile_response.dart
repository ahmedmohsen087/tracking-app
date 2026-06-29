import 'package:flowery_rider_app/features/profile/data/models/driver_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_profile_response.g.dart';

@JsonSerializable()
class EditProfileResponse {
  @JsonKey(name: 'message')
  String? message;

  @JsonKey(name: 'driver')
  DriverProfileModel? driver;

  EditProfileResponse({this.message, this.driver});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$EditProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EditProfileResponseToJson(this);
}
