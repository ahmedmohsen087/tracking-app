import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/data/models/profile_response_model.dart';

abstract interface class ProfileRemoteDataSourceContract {
  Future<BaseResponse<ProfileResponseModel>> changePassword({
    required ProfileRequestModel request,
  });
}
