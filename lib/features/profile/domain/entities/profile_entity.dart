import 'package:equatable/equatable.dart';

class ProfileResponseEntity extends Equatable {
  final String? message;
  final String? token;

  const ProfileResponseEntity({this.message, this.token});

  @override
  List<Object?> get props => [message, token];

  ProfileResponseEntity copyWith({String? message, String? token}) {
    return ProfileResponseEntity(
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }
}
