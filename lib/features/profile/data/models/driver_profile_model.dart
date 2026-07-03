import 'package:flowery_rider_app/features/profile/domain/entities/driver_profile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'driver_profile_model.g.dart';

@JsonSerializable()
class DriverProfileModel {
  @JsonKey(name: '_id')
  String? id;

  @JsonKey(name: 'firstName')
  String? firstName;

  @JsonKey(name: 'lastName')
  String? lastName;

  @JsonKey(name: 'email')
  String? email;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'photo')
  String? photo;

  @JsonKey(name: 'gender')
  String? gender;

  @JsonKey(name: 'country')
  String? country;

  @JsonKey(name: 'role')
  String? role;

  @JsonKey(name: 'createdAt')
  DateTime? createdAt;

  DriverProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.gender,
    this.country,
    this.role,
    this.createdAt,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) =>
      _$DriverProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverProfileModelToJson(this);

  DriverProfileEntity toEntity() {
    return DriverProfileEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      photo: photo,
      gender: gender,
      country: country,
      role: role,
      createdAt: createdAt,
    );
  }
}
