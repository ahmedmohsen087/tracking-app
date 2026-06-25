import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';

extension ProfileResponseModelMapper on ProfileResponseModel {
  ProfileResponseEntity toEntity() {
    return ProfileResponseEntity(message: message, token: token);
  }
}
