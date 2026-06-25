import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/edit_profile_response_entity.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<EditProfileResponseEntity>> editProfile({
    required EditProfileRequestModel requestModel,
  });

  Future<BaseResponse<String>> uploadPhoto({required String filePath});
}
