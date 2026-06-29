import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/profile_driver_entity.dart';
part 'profile_driver.g.dart';
@JsonSerializable()
class ProfileDriver {
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

  ProfileDriver({
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

  factory ProfileDriver.fromJson(Map<String, dynamic> json) => _$ProfileDriverFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileDriverToJson(this);

  ProfileDriverEntity toDomain() => ProfileDriverEntity(
   id: id??'',
   country: country??'',
   firstName: firstName??'',
   lastName: lastName??'',
   vehicleType: vehicleType ??'',
   vehicleNumber: vehicleNumber??'',
   vehicleLicense: vehicleLicense??'',
   nid: nid??'',
   nidImg: nidImg??'',
   email: email??'',
   gender: gender??'',
   phone: phone??'',
   photo: photo??'',
   role: role??'',
   createdAt: createdAt??DateTime.now(),

 );




}