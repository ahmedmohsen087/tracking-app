import 'package:equatable/equatable.dart';
import 'package:flowery_rider_app/core/entities/user_entity.dart';

class AuthResponseEntity extends Equatable {
  final String message;
  final UserEntity userEntity;
  final String token;

  const AuthResponseEntity({
    required this.message,
    required this.userEntity,
    required this.token,
  });

  @override
  List<Object?> get props => [message, userEntity, token];
}
