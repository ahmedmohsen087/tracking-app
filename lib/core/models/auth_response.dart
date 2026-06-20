import 'package:flowery_rider_app/core/entities/auth_response_entity.dart';
import 'package:flowery_rider_app/core/entities/user_entity.dart';
import 'package:flowery_rider_app/core/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "user")
  User? user;
  @JsonKey(name: "token")
  String? token;

  AuthResponse({this.message, this.user, this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

extension AuthResponseMapper on AuthResponse {
  AuthResponseEntity toEntity() {
    return AuthResponseEntity(
      message: message ?? '',
      token: token ?? '',
      userEntity:
          user?.toEntity() ??
          UserEntity(
            id: '',
            firstName: '',
            lastName: '',
            email: '',
            gender: '',
            phone: '',
            photo: '',
            role: '',
            wishlist: const [],
            addresses: const [],
            createdAt: DateTime.now(),
          ),
    );
  }
}
