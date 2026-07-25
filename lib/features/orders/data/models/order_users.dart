import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/order_users_entity.dart';
part 'order_users.g.dart';
@JsonSerializable()
class OrderUsers {
  @JsonKey(name: "_id")
  String? id;
  @JsonKey(name: "firstName")
  String? firstName;
  @JsonKey(name: "lastName")
  String? lastName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "phone")
  String? phone;
  @JsonKey(name: "photo")
  String? photo;
  @JsonKey(name: "passwordChangedAt")
  DateTime? passwordChangedAt;
  @JsonKey(name: "resetCodeVerified")
  bool? resetCodeVerified;

  OrderUsers({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.passwordChangedAt,
    this.resetCodeVerified,
  });

  factory OrderUsers.fromJson(Map<String, dynamic> json) => _$OrderUsersFromJson(json);

  Map<String, dynamic> toJson() => _$OrderUsersToJson(this);
  OrderUsersEntity toDomain (){
    return OrderUsersEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
      passwordChangedAt: passwordChangedAt ?? DateTime.now(),
      resetCodeVerified: resetCodeVerified ?? false,
    );
  }
}