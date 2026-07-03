import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? photo;
  final String? gender;
  final String? country;
  final String? role;
  final String? vehicleType;
  final String? vehicleNumber;
  final String? vehicleLicense;
  final String? nid;
  final String? nidImg;
  final DateTime? createdAt;

  const DriverEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.photo,
    this.gender,
    this.country,
    this.role,
    this.vehicleType,
    this.vehicleNumber,
    this.vehicleLicense,
    this.nid,
    this.nidImg,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        photo,
        gender,
        country,
        role,
        vehicleType,
        vehicleNumber,
        vehicleLicense,
        nid,
        nidImg,
        createdAt,
      ];

  DriverEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? photo,
    String? gender,
    String? country,
    String? role,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleLicense,
    String? nid,
    String? nidImg,
    DateTime? createdAt,
  }) {
    return DriverEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      role: role ?? this.role,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      vehicleLicense: vehicleLicense ?? this.vehicleLicense,
      nid: nid ?? this.nid,
      nidImg: nidImg ?? this.nidImg,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}