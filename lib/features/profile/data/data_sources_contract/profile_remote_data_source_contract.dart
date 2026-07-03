import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/edit_vehicle_info_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/api/responses/edit_profile_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/upload_photo_response.dart';
import 'package:flowery_rider_app/features/profile/api/responses/vehicle_types_response.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';

import '../models/get_profile_response.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<EditProfileResponse>> editProfile({
    required EditProfileRequestModel requestModel,
  });
  Future<BaseResponse<GetProfileResponse>> getProfile();

  Future<BaseResponse<UploadPhotoResponse>> uploadPhoto({
    required String filePath,
  });

  Future<BaseResponse<VehicleTypesResponse>> getVehicleTypes({
    required int page,
    required int limit,
  });

  Future<BaseResponse<String>> editVehicleInfo({
    required EditVehicleInfoRequestModel requestModel,
  });

  Future<BaseResponse<ProfileResponseModel>> changePassword({
    required ProfileRequestModel request,
  });
}



