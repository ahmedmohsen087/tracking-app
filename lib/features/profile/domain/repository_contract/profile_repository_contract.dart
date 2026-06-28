import 'package:flowery_rider_app/config/base_response/base_response.dart';
import 'package:flowery_rider_app/features/profile/api/request_models/profile_request_model.dart';
import 'package:flowery_rider_app/features/profile/domain/entities/profile_entity.dart';

abstract interface class ProfileRepositoryContract {
  Future<BaseResponse<ProfileResponseEntity>> changePassword({
    required ProfileRequestModel requestModel,
  });
}
