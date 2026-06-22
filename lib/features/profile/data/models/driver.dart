import 'package:json_annotation/json_annotation.dart';

import '../../../auth/domain/entities/driver_entity.dart';
part 'driver.g.dart';
@JsonSerializable()
class Driver {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "country")
  String? country;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "vehicleType")
  String? vehicleType;
  @JsonKey(name: "vehicleNumber")
  String? vehicleNumber;
  @JsonKey(name: "vehicleLicense")
  String? vehicleLicense;
  @JsonKey(name: "NID")
  String? nid;
  @JsonKey(name: "NIDImg")
  String? nidImg;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;

  Driver({
    this.id,
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
    this.createdAt,
  });

  factory Driver.fromJson(Map<String, dynamic> json) => _$DriverFromJson(json);

  Map<String, dynamic> toJson() => _$DriverToJson(this);

 DriverEntity toDomain() => DriverEntity(
   id: id,
   country: country,
   firstName: firstName,
   lastName: lastName,
   vehicleType: vehicleType,
   vehicleNumber: vehicleNumber,
   vehicleLicense: vehicleLicense,
   nid: nid,
   nidImg: nidImg,
   email: email,
   gender: gender,
   phone: phone,
   photo: photo,
   role: role,
   createdAt: createdAt,

 );




}