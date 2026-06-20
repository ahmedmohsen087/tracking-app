import 'package:flowery_rider_app/core/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
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
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "wishlist")
  List<dynamic>? wishlist;
  @JsonKey(name: "_id", readValue: _readId)
  String? id;
  @JsonKey(name: "addresses")
  List<dynamic>? addresses;
  @JsonKey(name: "createdAt")
  DateTime? createdAt;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.phone,
    this.photo,
    this.role,
    this.wishlist,
    this.id,
    this.addresses,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

Object? _readId(Map json, String key) => json[key] ?? json['id'];

extension UserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
      role: role ?? '',
      wishlist: wishlist ?? const [],
      id: id ?? '',
      addresses: addresses ?? const [],
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
