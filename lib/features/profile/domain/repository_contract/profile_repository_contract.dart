import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<ProfileResponseEntity>> changePassword({
    required String newPassword,
    required String password,
  });
}
