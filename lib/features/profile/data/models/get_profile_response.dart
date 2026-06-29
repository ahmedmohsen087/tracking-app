import 'package:json_annotation/json_annotation.dart';

import 'profile_driver.dart';
part 'get_profile_response.g.dart';

@JsonSerializable()
class GetProfileResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "driver")
  ProfileDriver? driver;

  GetProfileResponse({
    this.message,
    this.driver,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) => _$GetProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetProfileResponseToJson(this);
}


