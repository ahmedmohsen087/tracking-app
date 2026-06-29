import 'package:equatable/equatable.dart';

class DriverProfileEntity extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? photo;
  final String? gender;
  final String? country;
  final String? role;
  final DateTime? createdAt;

  const DriverProfileEntity({
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
    createdAt,
  ];

  DriverProfileEntity copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? photo,
    String? gender,
    String? country,
    String? role,
    DateTime? createdAt,
  }) {
    return DriverProfileEntity(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photo: photo ?? this.photo,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
