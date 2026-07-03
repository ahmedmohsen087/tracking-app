import 'package:equatable/equatable.dart';
import 'driver_entity.dart';

class AuthResponseEntity extends Equatable {
  final String? message;
  final String? token;
  final DriverEntity? driver;

  const AuthResponseEntity({
    this.message,
    this.token,
    this.driver,
  });

  @override
  List<Object?> get props => [message, token, driver];

  AuthResponseEntity copyWith({
    String? message,
    String? token,
    DriverEntity? driver,
  }) {
    return AuthResponseEntity(
      message: message ?? this.message,
      token: token ?? this.token,
      driver: driver ?? this.driver,
    );
  }
}