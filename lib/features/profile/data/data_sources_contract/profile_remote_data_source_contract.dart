import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<EditProfileResponse>> editProfile({
    required EditProfileRequestModel requestModel,
  });

  Future<BaseResponse<UploadPhotoResponse>> uploadPhoto({
    required String filePath,
  });
}
