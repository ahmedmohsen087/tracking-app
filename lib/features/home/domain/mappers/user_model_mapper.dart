import 'package:flowery_rider_app/features/home/data/models/user.dart';
import 'package:flowery_rider_app/features/home/domain/entities/user_entity.dart';

extension UserModelMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: id ?? '',
      firstName: firstName ?? '',
      lastName: lastName ?? '',
      email: email ?? '',
      gender: gender ?? '',
      phone: phone ?? '',
      photo: photo ?? '',
    );
  }
}
