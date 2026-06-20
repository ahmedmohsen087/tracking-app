import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final String phone;
  final String photo;
  final String role;
  final List<dynamic> wishlist;
  final List<dynamic> addresses;
  final DateTime createdAt;

  const UserEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    required this.phone,
    required this.photo,
    required this.role,
    required this.wishlist,
    required this.id,
    required this.addresses,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    gender,
    phone,
    photo,
    role,
    wishlist,
    id,
    addresses,
    createdAt,
  ];
}
