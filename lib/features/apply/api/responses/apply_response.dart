import 'package:json_annotation/json_annotation.dart';

part 'apply_response.g.dart';

@JsonSerializable()
class ApplyResponse {
  final String? message;
  final DriverResponse? driver;
  final String? token;

  const ApplyResponse({this.message, this.driver, this.token});

  factory ApplyResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApplyResponseToJson(this);
}

@JsonSerializable()
class DriverResponse {
  final String? country;
  final String? firstName;
  final String? lastName;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;
  @JsonKey(name: 'NID')
  final String? nid;
  @JsonKey(name: 'NIDImg')
  final String? nidImg;
  final String? email;
  final String? gender;
  final String? phone;
  final String? photo;
  final String? role;
  @JsonKey(name: '_id')
  final String? id;
  final String? createdAt;

  const DriverResponse({
    this.country,
    this.firstName,
    this.lastName,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.id,
    this.createdAt,
  });

  factory DriverResponse.fromJson(Map<String, dynamic> json) =>
      _$DriverResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DriverResponseToJson(this);
}
